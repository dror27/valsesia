#!/usr/bin/env ruby

require "cgi"
require "fileutils"
require "yaml"

begin
  require "kramdown"
rescue LoadError
  KRAMDOWN_AVAILABLE = false
else
  KRAMDOWN_AVAILABLE = true
end

ROOT = File.expand_path("..", __dir__)
EXPORT_DIR = File.join(ROOT, "_exports")
ESSAY_GLOB = File.join(ROOT, "_essays_*", "*.md")
LANGUAGE_NAMES = {
  "en" => "English",
  "he" => "Hebrew",
  "it" => "Italian"
}.freeze

def parse_essay(file_path)
  content = File.read(file_path, encoding: "UTF-8")
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m)
  raise "Missing YAML front matter in #{file_path}" unless match

  metadata = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
  [metadata, match[2].to_s]
end

def language_from_path(file_path)
  File.basename(File.dirname(file_path)).sub("_essays_", "")
end

def word_html_body(markdown)
  if KRAMDOWN_AVAILABLE
    Kramdown::Document.new(markdown, input: "GFM").to_html
  else
    paragraphs = markdown.split(/\n{2,}/).map(&:strip).reject(&:empty?)
    paragraphs.map { |paragraph| "<p>#{CGI.escapeHTML(paragraph).gsub("\n", "<br>\n")}</p>" }.join("\n")
  end
end

def html_document(file_path, metadata, markdown)
  language_code = language_from_path(file_path)
  language_name = LANGUAGE_NAMES.fetch(language_code, language_code)
  escaped_language = CGI.escapeHTML(language_name)
  escaped_title = CGI.escapeHTML(metadata.fetch("title", ""))
  escaped_summary = CGI.escapeHTML(metadata.fetch("summary", ""))
  escaped_long_summary = CGI.escapeHTML(metadata.fetch("long_summary", ""))
  body_html = word_html_body(markdown)

  <<~HTML
    <!DOCTYPE html>
    <html lang="#{CGI.escapeHTML(language_code)}">
      <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="ProgId" content="Word.Document">
        <meta name="Generator" content="valsesia export_essays.rb">
        <title>#{escaped_title}</title>
        <style>
          body {
            font-family: Georgia, "Times New Roman", serif;
            font-size: 12pt;
            line-height: 1.6;
            margin: 2rem;
          }

          h1 {
            margin-bottom: 1.5rem;
          }

          h2 {
            margin-top: 1.75rem;
            margin-bottom: 0.5rem;
            font-size: 13pt;
          }

          p {
            margin: 0.5rem 0;
          }

          .field {
            margin-bottom: 1.5rem;
          }

          .label {
            font-weight: bold;
          }
        </style>
      </head>
      <body>
        <h1>#{escaped_title}</h1>

        <div class="field"><span class="label">Language:</span> #{escaped_language}</div>
        <div class="field"><span class="label">Summary:</span> #{escaped_summary}</div>
        <div class="field"><span class="label">Long summary:</span> #{escaped_long_summary}</div>

        <h2>Text</h2>
        #{body_html}
      </body>
    </html>
  HTML
end

def export_basename(file_path)
  language_code = language_from_path(file_path)
  "#{File.basename(file_path, ".md")}.#{language_code}.doc"
end

FileUtils.mkdir_p(EXPORT_DIR)

essay_paths = Dir.glob(ESSAY_GLOB).sort
abort "No essays found under #{ESSAY_GLOB}" if essay_paths.empty?

essay_paths.each do |file_path|
  metadata, markdown = parse_essay(file_path)
  output_path = File.join(EXPORT_DIR, export_basename(file_path))
  File.write(output_path, html_document(file_path, metadata, markdown), encoding: "UTF-8")
  puts "exported #{output_path}"
end

puts "Exported #{essay_paths.length} essays to #{EXPORT_DIR}"