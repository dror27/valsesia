---
layout: default
title: English
lang: en
dir: ltr
permalink: /en/
---

<section class="list-card">
  <h2>Essays in English</h2>
  <ul class="entry-list">
    {% assign en_items = site.essays_en | sort: 'date' | reverse %}
    {% for item in en_items %}
      <li>
        <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
        <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
      </li>
    {% endfor %}
  </ul>
</section>
