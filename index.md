---
layout: default
title: Home
lang: he
dir: rtl
---

{% assign all_items = site.essays_he | concat: site.essays_it | concat: site.essays_en | sort: 'date' | reverse %}
{% assign tags_csv = '' %}
{% for item in all_items %}
  {% if item.tags %}
    {% assign tags_csv = tags_csv | append: item.tags | join: '|' | append: '|' %}
  {% endif %}
{% endfor %}
{% assign all_tags = tags_csv | split: '|' | uniq | sort %}

<section class="hero" lang="he" dir="rtl">
  <h1>{{ site.title }}</h1>
  <p>{{ site.description }}</p>
  <p>אסופות של מסות, רשימות והרהורים.</p>
  <div class="hero-actions">
    <a class="preferred-link" data-preferred-lang-link="{{ '/' | relative_url }}" href="#" hidden>Go to preferred language</a>
    <div class="mode-switch" role="group" aria-label="Homepage view mode">
      <button class="mode-btn" type="button" data-mode-button="abstracts" aria-pressed="false">Abstracts</button>
      <button class="mode-btn" type="button" data-mode-button="compact" aria-pressed="false">Compact</button>
    </div>
  </div>
</section>

<section class="grid" data-home-mode-target data-home-mode-default="abstracts">
  <article class="list-card">
    <h2>Recent Essays</h2>

    <ul class="entry-list mode-abstracts">
      {% for item in all_items limit: 8 %}
        <li lang="{{ item.lang | default: 'he' }}" dir="{{ item.dir | default: 'ltr' }}">
          <div class="abstract-title">
            <a href="{{ item.url | relative_url }}">{{ item.title | default: item.name | replace: '.md', '' }}</a>
            <span class="tag">{{ item.lang | upcase }}</span>
          </div>
          <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.author %} · {{ item.author }}{% endif %}</div>
          {% if item.long_summary %}
            <p class="abstract-summary">{{ item.long_summary }}</p>
          {% elsif item.summary %}
            <p class="abstract-summary">{{ item.summary }}</p>
          {% else %}
            <p class="abstract-summary">{{ item.content | markdownify | strip_html | truncatewords: 45 }}</p>
          {% endif %}
          {% if item.tags %}
            <ul class="topic-list">
              {% for topic in item.tags limit: 4 %}
                <li><a href="{{ '/topics/#' | append: topic | slugify | relative_url }}">{{ topic }}</a></li>
              {% endfor %}
            </ul>
          {% endif %}
        </li>
      {% endfor %}
    </ul>

    <ul class="entry-list mode-compact">
      {% for item in all_items limit: 12 %}
        <li lang="{{ item.lang | default: 'he' }}" dir="{{ item.dir | default: 'ltr' }}">
          <a href="{{ item.url | relative_url }}">{{ item.title | default: item.name | replace: '.md', '' }}</a>
          <span class="tag">{{ item.lang | upcase }}</span>
          <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.author %} · {{ item.author }}{% endif %}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
        </li>
      {% endfor %}
    </ul>
  </article>

  <aside class="list-card">
    <h2>By Language</h2>
    <ul class="entry-list">
      <li><a href="{{ '/he/' | relative_url }}">עברית</a> ({{ site.essays_he | size }})</li>
      <li><a href="{{ '/it/' | relative_url }}">Italiano</a> ({{ site.essays_it | size }})</li>
      <li><a href="{{ '/en/' | relative_url }}">English</a> ({{ site.essays_en | size }})</li>
      <li><a href="{{ '/contents/' | relative_url }}">All Contents</a></li>
    </ul>

    <h2 style="margin-top: 1.2rem;">Topics</h2>
    <ul class="topic-list">
      {% for topic in all_tags limit: 10 %}
        {% unless topic == '' %}
          <li><a href="{{ '/topics/#' | append: topic | slugify | relative_url }}">{{ topic }}</a></li>
        {% endunless %}
      {% endfor %}
    </ul>
  </aside>
</section>
