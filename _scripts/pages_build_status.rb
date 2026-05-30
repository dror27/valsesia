#!/usr/bin/env ruby

require "json"
require "net/http"
require "optparse"
require "shellwords"
require "time"
require "uri"

ROOT = File.expand_path("..", __dir__)
GIT_REMOTE_COMMAND = "git -C #{Shellwords.escape(ROOT)} remote get-url origin"
PAGES_WORKFLOW_PATH_FRAGMENT = "pages-build-deployment"

def parse_options
  options = {
    repo: nil,
    json: false,
    limit: 20,
  }

  OptionParser.new do |parser|
    parser.banner = "Usage: ruby _scripts/pages_build_status.rb [options]"

    parser.on("--repo OWNER/REPO", "GitHub repository slug. Defaults to origin remote.") do |repo|
      options[:repo] = repo
    end

    parser.on("--limit COUNT", Integer, "How many recent Actions runs to inspect. Default: 20") do |count|
      options[:limit] = count
    end

    parser.on("--json", "Print the matched workflow run as JSON") do
      options[:json] = true
    end
  end.parse!

  options
end

def origin_repo_slug
  remote_url = `#{GIT_REMOTE_COMMAND}`.strip
  abort "Could not resolve origin remote." if remote_url.empty?

  ssh_match = remote_url.match(%r{\Agit@github\.com:(.+?)(?:\.git)?\z})
  return ssh_match[1] if ssh_match

  https_match = remote_url.match(%r{\Ahttps://github\.com/(.+?)(?:\.git)?\z})
  return https_match[1] if https_match

  abort "Unsupported origin remote format: #{remote_url}"
end

def github_get_json(url)
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/vnd.github+json"
  request["User-Agent"] = "valsesia-pages-build-status"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(request)
  end

  unless response.is_a?(Net::HTTPSuccess)
    abort "GitHub API request failed: #{response.code} #{response.message}"
  end

  JSON.parse(response.body)
end

def fetch_latest_pages_run(repo_slug, limit)
  api_url = "https://api.github.com/repos/#{repo_slug}/actions/runs?per_page=#{limit}"
  payload = github_get_json(api_url)
  runs = payload.fetch("workflow_runs", [])

  runs.find do |run|
    run["path"].to_s.include?(PAGES_WORKFLOW_PATH_FRAGMENT) ||
      run["name"].to_s.casecmp("pages build and deployment").zero?
  end
end

def format_timestamp(value)
  return "unknown" if value.to_s.empty?

  Time.parse(value).utc.iso8601
rescue ArgumentError
  value
end

options = parse_options
repo_slug = options[:repo] || origin_repo_slug
pages_run = fetch_latest_pages_run(repo_slug, options[:limit])

abort "No Pages build run found in the latest #{options[:limit]} workflow runs for #{repo_slug}." unless pages_run

if options[:json]
  puts JSON.pretty_generate(pages_run)
  exit 0
end

puts "Repository: #{repo_slug}"
puts "Workflow:   #{pages_run['name']}"
puts "Status:     #{pages_run['status']}"
puts "Conclusion: #{pages_run['conclusion'] || 'pending'}"
puts "Branch:     #{pages_run['head_branch']}"
puts "Commit:     #{pages_run['head_sha']}"
puts "Started:    #{format_timestamp(pages_run['run_started_at'])}"
puts "Updated:    #{format_timestamp(pages_run['updated_at'])}"
puts "Run URL:    #{pages_run['html_url']}"