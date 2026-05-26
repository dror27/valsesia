---
layout: default
title: Topics
lang: en
dir: ltr
permalink: /topics/
---

{% assign all_items = site.essays_he | concat: site.essays_it | concat: site.essays_en | sort: 'date' | reverse %}
{% assign tags_csv = '' %}
{% for item in all_items %}
  {% if item.tags %}
    {% assign tags_csv = tags_csv | append: item.tags | join: '|' | append: '|' %}
  {% endif %}
{% endfor %}
{% assign all_tags = tags_csv | split: '|' | uniq | sort %}

<section class="list-card">
  <h2>Topics Index</h2>
  <ul class="topic-list">
    {% for topic in all_tags %}
      {% unless topic == '' %}
        <li><a href="#{{ topic | slugify }}">{{ topic }}</a></li>
      {% endunless %}
    {% endfor %}
  </ul>
</section>

{% for topic in all_tags %}
  {% unless topic == '' %}
    <section class="list-card topic-anchor" style="margin-top: 1rem;" id="{{ topic | slugify }}">
      <h2>{{ topic }}</h2>
      <ul class="entry-list">
        {% for item in all_items %}
          {% if item.tags contains topic %}
            <li lang="{{ item.lang | default: 'he' }}" dir="{{ item.dir | default: 'ltr' }}">
              <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
              <span class="tag">{{ item.lang | upcase }}</span>
              <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
            </li>
          {% endif %}
        {% endfor %}
      </ul>
    </section>
  {% endunless %}
{% endfor %}
