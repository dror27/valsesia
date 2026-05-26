---
layout: default
title: עברית
lang: he
dir: rtl
permalink: /he/
---

<section class="list-card" lang="he" dir="rtl">
  <h2>מאמרים בעברית</h2>
  <ul class="entry-list">
    {% assign he_items = site.essays_he | sort: 'date' | reverse %}
    {% for item in he_items %}
      <li>
        <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
        <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
      </li>
    {% endfor %}
  </ul>
</section>
