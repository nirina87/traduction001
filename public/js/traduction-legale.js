(function () {
  var topbar = document.querySelector('.topbar');
  var burger = document.querySelector('.nav-burger');
  var nav = document.getElementById('main-nav');

  if (topbar && burger && nav) {
    function setNavOpen(open) {
      topbar.classList.toggle('is-nav-open', open);
      burger.setAttribute('aria-expanded', open ? 'true' : 'false');
      burger.setAttribute('aria-label', open ? 'Fermer le menu' : 'Ouvrir le menu');
    }

    burger.addEventListener('click', function () {
      setNavOpen(!topbar.classList.contains('is-nav-open'));
    });

    nav.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        setNavOpen(false);
      });
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        setNavOpen(false);
      }
    });
  }

  var btn = document.getElementById('docs-show-all');
  if (btn) {
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
  }

  var form = document.getElementById('contactForm');
  if (!form) {
    return;
  }

  var submitBtn = form.querySelector('.form-submit');
  var successEl = document.getElementById('formSuccess');
  var errorEl = document.getElementById('formError');
  var defaultLabel = submitBtn ? submitBtn.textContent : '';

  form.addEventListener('submit', function (e) {
    e.preventDefault();

    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    var fd = new FormData(form);
    var docType = fd.get('docType') || '';
    var lang = fd.get('lang') || '';
    var message = fd.get('message') || '';
    var parts = [];

    if (docType) {
      parts.push('Type de document : ' + docType);
    }
    if (lang) {
      parts.push('Langue souhaitée : ' + lang);
    }
    if (parts.length) {
      message = parts.join('\n') + (message ? '\n\n' + message : '');
    }

    var body = new FormData();
    body.append('prenom', fd.get('firstName') || '');
    body.append('nom', fd.get('lastName') || '');
    body.append('email', fd.get('email') || '');
    body.append('telephone', fd.get('phone') || '');
    body.append('message', message || '(Aucun message complémentaire)');

    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.textContent = 'Envoi en cours...';
    }
    if (errorEl) {
      errorEl.classList.remove('show');
    }

    fetch(form.getAttribute('data-action'), {
      method: 'POST',
      body: body
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        if (data.success) {
          form.style.display = 'none';
          if (successEl) {
            successEl.classList.add('show');
          }
          form.dispatchEvent(new CustomEvent('tl:contact-success'));
          return;
        }

        if (errorEl) {
          errorEl.classList.add('show');
        }
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.textContent = defaultLabel;
        }
      })
      .catch(function () {
        if (errorEl) {
          errorEl.classList.add('show');
        }
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.textContent = defaultLabel;
        }
      });
  });
})();
