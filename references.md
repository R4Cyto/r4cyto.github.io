---
layout: default
title: References
---

# References

{% assign sorted_refs = site.references | sort: 'year' | reverse %}

{% for ref in sorted_refs %}
<div class="reference">
  <h3><a href="{{ ref.url }}">{{ ref.title }}</a></h3>
  <p><strong>Authors:</strong> {{ ref.author }}</p>
  <p><strong>Year:</strong> {{ ref.year }} | <strong>Source:</strong> {{ ref.source }}</p>
  <p><strong>DOI:</strong> <a href="{{ ref.url }}" target="_blank">{{ ref.url }}</a></p>
  {% if ref.editor_comment != "" %}
  <p><em>{{ ref.editor_comment }}</em></p>
  {% endif %}
  <p><a href="{{ ref.url }}">View detailed notes →</a></p>
</div>
{% endfor %}
