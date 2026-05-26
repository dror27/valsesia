---
layout: default
title: Home
lang: he
dir: rtl
---

{% assign all_items = site.essays_he | concat: site.essays_it | concat: site.essays_en | sort: 'date' | reverse %}

<section class="hero" lang="he" dir="rtl">
  <h1>עמוק בעמק</h1>
  <p>הגות בוולססיה · אסופות של מסות, רשימות והרהורים.</p>
</section>

<section class="grid">
  <article class="list-card">
    <h2>Recent Items</h2>
    <ul class="entry-list">
      {% for item in all_items limit: 8 %}
        <li lang="{{ item.lang | default: 'he' }}" dir="{{ item.dir | default: 'ltr' }}">
          <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
          <span class="tag">{{ item.lang | upcase }}</span>
          <div class="meta">{{ item.date | date: "%Y-%m-%d" }}{% if item.summary %} · {{ item.summary }}{% endif %}</div>
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
  </aside>
</section>
