---
layout: default
title: References
---

# References

<div class="controls-container">
  <div class="search-container">
    <input type="text" id="search-box" placeholder="Search references by title, author, year, or source..." />
  </div>
  
  <div class="sort-container">
    <label for="sort-select">Sort by:</label>
    <select id="sort-select">
      <option value="year-desc">Year (Newest First)</option>
      <option value="year-asc">Year (Oldest First)</option>
      <option value="modified-desc">Last Modified (Newest First)</option>
      <option value="modified-asc">Last Modified (Oldest First)</option>
      <option value="author-asc">Author (A-Z)</option>
    </select>
  </div>
  
  <p id="search-count"></p>
</div>

<div id="references-list">
{% assign sorted_refs = site.references | sort: 'year' | reverse %}

{% for ref in sorted_refs %}
<div class="reference" 
     data-title="{{ ref.title | downcase }}" 
     data-author="{{ ref.author | downcase }}" 
     data-year="{{ ref.year }}" 
     data-source="{{ ref.source | downcase }}"
     data-modified="{{ ref.last_modified | default: '1970-01-01' }}"
     data-author-sort="{{ ref.author_key | downcase }}">
  <h3><a href="{{ ref.url }}">{{ ref.title }}</a></h3>
  <p><strong>Authors:</strong> {{ ref.author }}</p>
  <p><strong>Year:</strong> {{ ref.year }} | <strong>Source:</strong> {{ ref.source }}</p>
  {% if ref.last_modified %}
  <p><strong>Last Modified:</strong> {{ ref.last_modified }}</p>
  {% endif %}
  <p><strong>DOI:</strong> <a href="{{ ref.doi }}" target="_blank">{{ ref.doi }}</a></p>
  {% if ref.editor_comment != "" %}
  <p><em>{{ ref.editor_comment }}</em></p>
  {% endif %}
  <p><a href="{{ ref.url }}">View detailed notes →</a></p>
</div>
{% endfor %}
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const searchBox = document.getElementById('search-box');
  const sortSelect = document.getElementById('sort-select');
  const referencesList = document.getElementById('references-list');
  const references = Array.from(document.querySelectorAll('.reference'));
  const searchCount = document.getElementById('search-count');
  const totalCount = references.length;

  function updateCount() {
    const visibleRefs = references.filter(ref => ref.style.display !== 'none');
    if (searchBox.value.trim() === '') {
      searchCount.textContent = `Showing all ${totalCount} references`;
    } else {
      searchCount.textContent = `Showing ${visibleRefs.length} of ${totalCount} references`;
    }
  }

  function sortReferences() {
    const sortValue = sortSelect.value;
    
    references.sort(function(a, b) {
      let aVal, bVal;
      
      switch(sortValue) {
        case 'year-desc':
          aVal = parseInt(a.getAttribute('data-year'));
          bVal = parseInt(b.getAttribute('data-year'));
          return bVal - aVal;
        
        case 'year-asc':
          aVal = parseInt(a.getAttribute('data-year'));
          bVal = parseInt(b.getAttribute('data-year'));
          return aVal - bVal;
        
        case 'modified-desc':
          aVal = new Date(a.getAttribute('data-modified'));
          bVal = new Date(b.getAttribute('data-modified'));
          return bVal - aVal;
        
        case 'modified-asc':
          aVal = new Date(a.getAttribute('data-modified'));
          bVal = new Date(b.getAttribute('data-modified'));
          return aVal - bVal;
        
        case 'author-asc':
          aVal = a.getAttribute('data-author-sort');
          bVal = b.getAttribute('data-author-sort');
          return aVal.localeCompare(bVal);
        
        default:
          return 0;
      }
    });
    
    // Re-append sorted elements
    references.forEach(ref => referencesList.appendChild(ref));
  }

  function filterReferences() {
    const searchTerm = searchBox.value.toLowerCase().trim();

    references.forEach(function(ref) {
      if (searchTerm === '') {
        ref.style.display = '';
        return;
      }

      const title = ref.getAttribute('data-title');
      const author = ref.getAttribute('data-author');
      const year = ref.getAttribute('data-year');
      const source = ref.getAttribute('data-source');

      const matches = title.includes(searchTerm) || 
                     author.includes(searchTerm) || 
                     year.includes(searchTerm) || 
                     source.includes(searchTerm);

      ref.style.display = matches ? '' : 'none';
    });

    updateCount();
  }

  updateCount();
  
  searchBox.addEventListener('input', filterReferences);
  sortSelect.addEventListener('change', sortReferences);
});
</script>
