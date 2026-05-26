---
layout: default
title: Italiano
lang: it
dir: ltr
permalink: /it/
---

<section class="list-card">
  <h2>Saggi in Italiano</h2>
  <ul class="entry-list">
    {% assign it_items = site.essays_it | sort: 'date' | reverse %}
    {% for item in it_items %}
      <li>
        <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
        <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
      </li>
    {% endfor %}
  </ul>
</section>
