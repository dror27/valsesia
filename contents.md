---
layout: default
title: Contents
lang: en
dir: ltr
permalink: /contents/
---

<section class="list-card" lang="he" dir="rtl">
  <h2>עברית</h2>
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

<section class="list-card" style="margin-top: 1rem;">
  <h2>Italiano</h2>
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

<section class="list-card" style="margin-top: 1rem;">
  <h2>English</h2>
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
