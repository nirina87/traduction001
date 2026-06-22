(function () {
  var btn = document.getElementById('docs-show-all');
  if (!btn) {
    return;
  }

  btn.addEventListener('click', function () {
    var grid = document.getElementById('docs-grid');
    var footer = document.getElementById('docs-grid-footer');
    if (grid) {
      grid.classList.add('is-expanded');
    }
    if (footer) {
      footer.style.display = 'none';
    }
  });
})();
