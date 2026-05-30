# עמוק בעמק

הגות בוולססיה

A small multilingual essays site, designed for GitHub Pages.

## Structure

- `_essays_he/` Hebrew essays (RTL)
- `_essays_it/` Italian essays
- `_essays_en/` English essays
- `_layouts/` shared page and essay layouts
- `_includes/` reusable header/footer templates
- `assets/css/style.css` site styles
- `index.md` home page (recent items)
- `contents.md` table of contents by language
- `topics.md` topic/tag index page

## Features

- Language switcher remembers the reader's preferred language.
- Home page supports two views:
   - `Abstracts` (default): longer summaries
   - `Compact`: denser list view
- Topic system based on `tags` front matter.

## Local Preview (optional)

1. Install Ruby and Bundler.
2. Run:

   bundle install
   bundle exec jekyll serve --baseurl ""

3. Open http://127.0.0.1:4000

## GitHub Pages Build Status

To check the latest GitHub Pages deployment status for this repository:

   ruby _scripts/pages_build_status.rb

Optional flags:

   ruby _scripts/pages_build_status.rb --json
   ruby _scripts/pages_build_status.rb --repo dror27/valsesia

## Export Essays For Editing

Run:

   ruby _scripts/export_essays.rb

This exports one Word-openable `.doc` file per essay into `_exports/`.

## Add New Essays

Add a new Markdown file in the relevant collection folder, for example:

- `_essays_he/מסע-בוואלססיה.md`
- `_essays_it/viaggio-in-valsesia.md`
- `_essays_en/journey-in-valsesia.md`

Please try to use ASCII characters for all filenames and tags.

Use front matter like:

---
title: "כותרת המאמר"
date: 2026-05-27
summary: "תקציר קצר"
long_summary: "תקציר ארוך יותר לדף הבית במצב Abstracts"
tags:
   - living
   - love
---

Then write your text in Markdown below.

## Audio On GitHub Pages

GitHub Pages serves files from the repository contents in the branch. It does not publish Git LFS media payloads for this site, so audio files under `assets/readings/` must be committed as normal Git binaries, not as LFS pointers.

If an MP3 was previously tracked by LFS, re-stage it after updating `.gitattributes`:

   git add --renormalize assets/readings/*.mp3

Then commit and push so GitHub Pages publishes the real file instead of the small LFS pointer.
