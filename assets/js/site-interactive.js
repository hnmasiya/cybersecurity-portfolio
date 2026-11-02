/*
 * Masiya Hub — interactive layer for the home page (index.html).
 * Additive only: it does not replace or edit any existing function, and it uses
 * addEventListener (never window.onscroll = ...) so the existing scripts keep working.
 * If this file fails to load, the page works exactly as before.
 *
 *  1. Motion & polish  : scroll reveal, count-up stats, card spotlight, active nav link
 *  2. Search & filters : "/" search palette, clickable tag filters, filter-button counts
 *  3. Lab explorers    : MITRE ATT&CK coverage explorer, "read more" on long descriptions
 */
(function () {
  'use strict';

  var doc = document;
  var root = doc.documentElement;
  var reduce = !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  var canHover = !!(window.matchMedia && window.matchMedia('(hover: hover)').matches);

  function $(s, c) { return (c || doc).querySelector(s); }
  function $$(s, c) { return Array.prototype.slice.call((c || doc).querySelectorAll(s)); }
  function h(tag, cls, text) {
    var n = doc.createElement(tag);
    if (cls) n.className = cls;
    if (text != null) n.textContent = text;
    return n;
  }
  function norm(s) { return String(s || '').replace(/\s+/g, ' ').trim(); }
  function scrollBehavior() { return reduce ? 'auto' : 'smooth'; }

  /* ------------------------------------------------------------------ */
  /* 1. MOTION & POLISH                                                  */
  /* ------------------------------------------------------------------ */

  function initReveal() {
    if (reduce || !('IntersectionObserver' in window)) return;
    root.classList.add('js-motion');
    var targets = $$('.hero > *, .section-header, #work .card, #flagship-labs .card, .glass-card, #forage .card, #snapshot .card, #certs .card, #contact .card, #final-validation .card, #evidence-standard .card');
    targets.forEach(function (t) { t.classList.add('reveal'); });

    var io = new IntersectionObserver(function (entries) {
      var n = 0;
      entries.forEach(function (e) {
        if (!e.isIntersecting) return;
        var t = e.target;
        io.unobserve(t);
        t.style.transitionDelay = Math.min(n, 6) * 70 + 'ms';
        n += 1;
        t.classList.add('in');
        // hand control back to the normal hover transitions once the reveal is done
        setTimeout(function () {
          t.classList.remove('reveal', 'in');
          t.style.transitionDelay = '';
        }, 1000);
      });
    }, { threshold: 0.06, rootMargin: '0px 0px -6% 0px' });
    targets.forEach(function (t) { io.observe(t); });

    // safety net: never leave content hidden
    setTimeout(function () {
      $$('.reveal').forEach(function (t) { t.classList.add('in'); });
    }, 6000);
  }

  function initSpotlight() {
    if (!canHover) return;
    doc.addEventListener('pointermove', function (e) {
      var c = e.target && e.target.closest ? e.target.closest('.card, .glass-card') : null;
      if (!c) return;
      var r = c.getBoundingClientRect();
      c.style.setProperty('--mx', (e.clientX - r.left) + 'px');
      c.style.setProperty('--my', (e.clientY - r.top) + 'px');
    }, { passive: true });
  }

  function initScrollSpy() {
    var links = $$('header nav a[href^="#"]');
    var map = {};
    links.forEach(function (a) { map[a.getAttribute('href').slice(1)] = a; });
    if (map.work) map['attack-explorer'] = map.work;       // the explorer belongs to the Work section
    var ids = Object.keys(map);
    var ticking = false;

    function update() {
      ticking = false;
      var line = window.innerHeight * 0.35, best = null, bestTop = -Infinity;
      ids.forEach(function (id) {
        var s = doc.getElementById(id);
        if (!s) return;
        var r = s.getBoundingClientRect();
        // the section crossing the reading line; if several do, the one that started last
        if (r.top <= line && r.bottom > line && r.top > bestTop) { best = id; bestTop = r.top; }
      });
      links.forEach(function (a) {
        var on = best && map[best] === a;
        a.classList.toggle('active', !!on);
        if (on) a.setAttribute('aria-current', 'true'); else a.removeAttribute('aria-current');
      });
    }
    function onScroll() { if (!ticking) { ticking = true; requestAnimationFrame(update); } }
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll);
    update();
  }

  function countUp(node, target, suffix) {
    if (reduce || !('IntersectionObserver' in window)) { node.textContent = target + suffix; return; }
    node.textContent = '0' + suffix;
    var io = new IntersectionObserver(function (entries) {
      if (!entries[0].isIntersecting) return;
      io.disconnect();
      var t0 = null, dur = 1100;
      function step(ts) {
        if (t0 === null) t0 = ts;
        var p = Math.min((ts - t0) / dur, 1);
        var eased = 1 - Math.pow(1 - p, 3);
        node.textContent = Math.round(target * eased) + suffix;
        if (p < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    }, { threshold: 0.4 });
    io.observe(node);
  }

  function initStats() {
    var anchor = $('.hero .btn-cta-group');
    if (!anchor || $('.stats-strip')) return;
    var items = [];
    var sec = $('.hero-subtitle-secondary');
    var m = sec && /(\d+)\+?\s*Years/i.exec(sec.textContent);
    if (m) items.push([parseInt(m[1], 10), '+', 'Years enterprise IT']);
    items.push([$$('#flagship-labs .card').length, '', 'Flagship security labs']);
    items.push([$$('#work .project-item').length, '', 'Technical projects']);
    items.push([$$('#evidence-hubs .glass-card').length, '', 'Evidence hubs']);
    var techs = collectTechniques();
    if (techs.list.length) items.push([techs.list.length, '', 'ATT&CK techniques referenced']);

    var strip = h('div', 'stats-strip');
    strip.setAttribute('role', 'list');
    strip.setAttribute('aria-label', 'Portfolio at a glance');
    items.forEach(function (it) {
      if (!it[0]) return;
      var box = h('div', 'stat');
      box.setAttribute('role', 'listitem');
      var num = h('strong', null, it[0] + it[1]);
      box.appendChild(num);
      box.appendChild(h('span', null, it[2]));
      strip.appendChild(box);
      countUp(num, it[0], it[1]);
    });
    anchor.parentNode.insertBefore(strip, anchor.nextSibling);
  }

  /* ------------------------------------------------------------------ */
  /* 2. SEARCH & FILTERS                                                 */
  /* ------------------------------------------------------------------ */

  var SECTION_LABEL = {
    'flagship-labs': 'Flagship Labs',
    'evidence-hubs': 'Evidence Hubs',
    'work': 'Projects',
    'attack-explorer': 'ATT&CK',
    'forage': 'Virtual Experience',
    'github-projects': 'GitHub',
    'snapshot': 'Capabilities',
    'certs': 'Certifications'
  };

  /* ---- active tag / technique filter on the Projects grid ---- */
  var activeFilter = null; // {type:'tag'|'tech', value:string}
  var chipBar = null;

  function cardMatches(card, f) {
    if (!f) return true;
    if (f.type === 'tag') {
      return $$('.tag', card).some(function (t) { return norm(t.textContent).toLowerCase() === f.value.toLowerCase(); });
    }
    return new RegExp('\\b' + f.value + '\\b').test(card.textContent);
  }

  function applyFilter() {
    var cards = $$('#work .project-item');
    var shown = 0;
    cards.forEach(function (c) {
      var ok = cardMatches(c, activeFilter);
      c.classList.toggle('is-filtered-out', !ok);
      if (ok) shown += 1;
    });
    $$('.tag.is-active, .tech.is-active').forEach(function (n) { n.classList.remove('is-active'); n.removeAttribute('aria-pressed'); });
    if (activeFilter) {
      $$('#work .tag').forEach(function (t) {
        if (activeFilter.type === 'tag' && norm(t.textContent).toLowerCase() === activeFilter.value.toLowerCase()) {
          t.classList.add('is-active'); t.setAttribute('aria-pressed', 'true');
        }
      });
      $$('.tech').forEach(function (t) {
        if (activeFilter.type === 'tech' && t.getAttribute('data-id') === activeFilter.value) {
          t.classList.add('is-active'); t.setAttribute('aria-pressed', 'true');
        }
      });
    }
    renderChipBar(shown, cards.length);
  }

  function setFilter(f) {
    var same = activeFilter && f && activeFilter.type === f.type && activeFilter.value === f.value;
    activeFilter = same ? null : f;
    applyFilter();
    if (activeFilter && chipBar) {
      chipBar.scrollIntoView({ behavior: scrollBehavior(), block: 'start' });
    }
  }

  function renderChipBar(shown, total) {
    if (!chipBar) return;
    chipBar.textContent = '';
    if (!activeFilter) { chipBar.hidden = true; return; }
    chipBar.hidden = false;
    chipBar.appendChild(h('span', 'chip-label', activeFilter.type === 'tech' ? 'Technique' : 'Tag'));
    var chip = h('button', 'chip', activeFilter.value + '  ✕');
    chip.type = 'button';
    chip.setAttribute('aria-label', 'Clear filter ' + activeFilter.value);
    chip.addEventListener('click', function () { activeFilter = null; applyFilter(); });
    chipBar.appendChild(chip);
    var count = h('span', 'chip-count', shown + ' of ' + total + ' projects');
    count.setAttribute('role', 'status');
    chipBar.appendChild(count);
    if (!shown) chipBar.appendChild(h('span', 'chip-empty', 'No projects match this filter with the current category.'));
  }

  function initTagFilters() {
    var grid = $('#work .grid-2');
    if (!grid) return;
    chipBar = h('div', 'filter-chip-bar');
    chipBar.hidden = true;
    grid.parentNode.insertBefore(chipBar, grid);

    $$('#work .tag').forEach(function (t) {
      t.classList.add('tag-btn');
      t.setAttribute('role', 'button');
      t.setAttribute('tabindex', '0');
      t.setAttribute('title', 'Filter projects by this tag');
    });
    var work = $('#work');
    work.addEventListener('click', function (e) {
      var t = e.target.closest && e.target.closest('.tag-btn');
      if (t) setFilter({ type: 'tag', value: norm(t.textContent) });
    });
    work.addEventListener('keydown', function (e) {
      if (e.key !== 'Enter' && e.key !== ' ') return;
      var t = e.target.closest && e.target.closest('.tag-btn');
      if (!t) return;
      e.preventDefault();
      setFilter({ type: 'tag', value: norm(t.textContent) });
    });
  }

  /* ---- counts on the category filter buttons ---- */
  function updateCounts() {
    var items = $$('.project-item');
    $$('.filter-btn').forEach(function (b) {
      var m = /filterWork\('([a-z]+)'/.exec(b.getAttribute('onclick') || '');
      if (!m) return;
      var cat = m[1];
      var n = cat === 'all' ? items.length : items.filter(function (i) { return i.getAttribute('data-category') === cat; }).length;
      var c = $('.count', b);
      if (!c) { c = h('span', 'count'); b.appendChild(c); }
      c.textContent = String(n);
    });
  }

  function initCounts() {
    updateCounts();
    var grid = $('#auto-project-grid');
    if (grid && 'MutationObserver' in window) {
      new MutationObserver(updateCounts).observe(grid, { childList: true });
    }
  }

  /* ---- search palette ---- */
  var pal = null, palInput = null, palList = null, palStatus = null;
  var palResults = [], palActive = 0, palReturnFocus = null;

  function indexCards() {
    var out = [];
    $$('.card, .glass-card').forEach(function (c) {
      if (c.closest('.modal-overlay')) return;
      var t = $('h3, h4, .project-title', c);
      var title = t ? norm(t.textContent) : '';
      if (!title) return;
      var sec = c.closest('section');
      var sid = sec ? sec.id : '';
      out.push({
        el: c,
        title: title,
        section: SECTION_LABEL[sid] || '',
        raw: norm(c.innerText || c.textContent).replace(/\s*(Read more ▾|Show less ▴)/g, ''),
        text: norm(c.innerText || c.textContent).replace(/\s*(Read more ▾|Show less ▴)/g, '').toLowerCase(),
        tags: $$('.tag', c).map(function (x) { return norm(x.textContent).toLowerCase(); }).join(' | ')
      });
    });
    return out;
  }

  function highlight(node, text, tokens) {
    node.textContent = '';
    var lower = text.toLowerCase();
    var i = 0;
    while (i < text.length) {
      var best = -1, bestLen = 0;
      tokens.forEach(function (tk) {
        var p = lower.indexOf(tk, i);
        if (p !== -1 && (best === -1 || p < best)) { best = p; bestLen = tk.length; }
      });
      if (best === -1) { node.appendChild(doc.createTextNode(text.slice(i))); break; }
      if (best > i) node.appendChild(doc.createTextNode(text.slice(i, best)));
      node.appendChild(h('mark', null, text.slice(best, best + bestLen)));
      i = best + bestLen;
    }
  }

  function runSearch(q) {
    var tokens = norm(q).toLowerCase().split(' ').filter(Boolean);
    palList.textContent = '';
    palResults = [];
    palActive = 0;
    if (!tokens.length) {
      palStatus.textContent = 'Type to search labs, projects, tags, certifications and techniques (for example "sysmon" or "T1059").';
      return;
    }
    var scored = [];
    indexCards().forEach(function (it, order) {
      var ok = tokens.every(function (tk) { return it.text.indexOf(tk) !== -1; });
      if (!ok) return;
      var s = 1;
      tokens.forEach(function (tk) {
        if (it.title.toLowerCase().indexOf(tk) !== -1) s += 3;
        if (it.tags.indexOf(tk) !== -1) s += 2;
      });
      scored.push({ it: it, score: s, order: order });
    });
    scored.sort(function (a, b) { return b.score - a.score || a.order - b.order; });
    palResults = scored.slice(0, 30).map(function (s) { return s.it; });
    palStatus.textContent = palResults.length
      ? palResults.length + (scored.length > 30 ? '+' : '') + ' result' + (palResults.length === 1 ? '' : 's')
      : 'No results for "' + norm(q) + '".';

    palResults.forEach(function (it, idx) {
      var li = h('li', 'pal-item');
      li.id = 'pal-opt-' + idx;
      li.setAttribute('role', 'option');
      var top = h('div', 'pal-top');
      var title = h('span', 'pal-title');
      highlight(title, it.title, tokens);
      top.appendChild(title);
      if (it.section) top.appendChild(h('span', 'pal-sec', it.section));
      li.appendChild(top);
      var snip = it.raw;
      if (snip.indexOf(it.title) === 0) snip = norm(snip.slice(it.title.length));   // don't repeat the title
      var p = snip.toLowerCase().indexOf(tokens[0]);
      var start = Math.max(0, p - 50);
      var piece = (start > 0 ? '… ' : '') + snip.slice(start, start + 140) + (start + 140 < snip.length ? ' …' : '');
      var sn = h('div', 'pal-snip');
      highlight(sn, piece, tokens);
      li.appendChild(sn);
      li.addEventListener('mousemove', function () { setActive(idx, false); });
      li.addEventListener('click', function () { goTo(idx); });
      palList.appendChild(li);
    });
    setActive(0, false);
  }

  function setActive(i, scroll) {
    var items = $$('.pal-item', palList);
    if (!items.length) { palInput.removeAttribute('aria-activedescendant'); return; }
    palActive = (i + items.length) % items.length;
    items.forEach(function (n, k) {
      n.classList.toggle('active', k === palActive);
      n.setAttribute('aria-selected', k === palActive ? 'true' : 'false');
    });
    palInput.setAttribute('aria-activedescendant', items[palActive].id);
    if (scroll) items[palActive].scrollIntoView({ block: 'nearest' });
  }

  function goTo(idx) {
    var it = palResults[idx];
    if (!it) return;
    closePalette();
    var card = it.el;
    var hidden = card.offsetParent === null || card.classList.contains('is-filtered-out');
    if (hidden) {
      activeFilter = null;
      applyFilter();
      var all = $('.filter-btn');
      if (all) all.click();
    }
    setTimeout(function () {
      card.scrollIntoView({ behavior: scrollBehavior(), block: 'center' });
      card.classList.add('flash');
      setTimeout(function () { card.classList.remove('flash'); }, 2200);
    }, hidden ? 350 : 60);
  }

  function openPalette() {
    if (!pal) return;
    palReturnFocus = doc.activeElement;
    pal.hidden = false;
    doc.body.style.overflow = 'hidden';
    palInput.value = '';
    runSearch('');
    palInput.focus();                      // synchronous, so fast typing after "/" lands in the box
    setTimeout(function () { palInput.focus(); }, 30);
  }

  function closePalette() {
    if (!pal || pal.hidden) return;
    pal.hidden = true;
    doc.body.style.overflow = '';
    if (palReturnFocus && palReturnFocus.focus) palReturnFocus.focus();
  }

  function buildPalette() {
    pal = h('div', 'pal-overlay');
    pal.hidden = true;
    var panel = h('div', 'pal-panel');
    panel.setAttribute('role', 'dialog');
    panel.setAttribute('aria-modal', 'true');
    panel.setAttribute('aria-label', 'Search the portfolio');
    palInput = h('input', 'pal-input');
    palInput.type = 'text';
    palInput.placeholder = 'Search labs, projects, tags, techniques…';
    palInput.setAttribute('role', 'combobox');
    palInput.setAttribute('aria-expanded', 'true');
    palInput.setAttribute('aria-controls', 'pal-list');
    palInput.setAttribute('autocomplete', 'off');
    palInput.setAttribute('autocapitalize', 'off');
    palInput.setAttribute('spellcheck', 'false');
    palStatus = h('div', 'pal-status');
    palStatus.setAttribute('aria-live', 'polite');
    palList = h('ul', 'pal-list');
    palList.id = 'pal-list';
    palList.setAttribute('role', 'listbox');
    var foot = h('div', 'pal-foot');
    foot.appendChild(h('span', null, '↑ ↓ to move · Enter to open · Esc to close'));
    panel.appendChild(palInput);
    panel.appendChild(palStatus);
    panel.appendChild(palList);
    panel.appendChild(foot);
    pal.appendChild(panel);
    doc.body.appendChild(pal);

    pal.addEventListener('mousedown', function (e) { if (e.target === pal) closePalette(); });
    palInput.addEventListener('input', function () { runSearch(palInput.value); });
    palInput.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowDown') { e.preventDefault(); setActive(palActive + 1, true); }
      else if (e.key === 'ArrowUp') { e.preventDefault(); setActive(palActive - 1, true); }
      else if (e.key === 'Enter') { e.preventDefault(); goTo(palActive); }
      else if (e.key === 'Escape') { e.preventDefault(); closePalette(); }
      else if (e.key === 'Tab') { e.preventDefault(); }   // keep focus inside the dialog
    });

    // nav button (icon only so the header stays on one row)
    var nav = $('header nav');
    var first = nav && $('.btn-nav-action', nav);
    if (nav && first) {
      var b = h('button', 'btn-nav-action search-btn', '🔍');
      b.type = 'button';
      b.id = 'open-search';
      b.setAttribute('aria-label', 'Search the portfolio (press /)');
      b.setAttribute('title', 'Search (press /)');
      b.addEventListener('click', openPalette);
      nav.insertBefore(b, first);
    }

    // hint in the keyboard banner
    var banner = $('.kb-hint-banner');
    if (banner) {
      banner.appendChild(doc.createTextNode(' | '));
      banner.appendChild(h('span', 'kbd-key', '/'));
      banner.appendChild(doc.createTextNode(' Search'));
    }

    // while the palette is open, keep the page's own 1-4 / T shortcuts from firing behind it
    doc.addEventListener('keydown', function (e) {
      if (!pal.hidden && e.target !== palInput && e.key !== 'Escape') {
        e.stopPropagation();
        if (e.key.length === 1 && !e.ctrlKey && !e.metaKey) palInput.focus();
      }
    }, true);

    doc.addEventListener('keydown', function (e) {
      var tag = e.target && e.target.tagName ? e.target.tagName.toUpperCase() : '';
      var typing = tag === 'INPUT' || tag === 'TEXTAREA' || (e.target && e.target.isContentEditable);
      if ((e.key === 'k' || e.key === 'K') && (e.ctrlKey || e.metaKey)) {
        e.preventDefault();
        pal.hidden ? openPalette() : closePalette();
      } else if (e.key === '/' && !typing && !e.ctrlKey && !e.metaKey && !e.altKey) {
        e.preventDefault();
        openPalette();
      } else if (e.key === 'Escape' && !pal.hidden) {
        closePalette();
      } else if (e.key === 'Escape' && activeFilter && !typing) {
        activeFilter = null; applyFilter();
      }
    });
  }

  /* ------------------------------------------------------------------ */
  /* 3. LAB EXPLORERS                                                    */
  /* ------------------------------------------------------------------ */

  // Technique names and primary tactic per MITRE ATT&CK (Enterprise).
  var TECH = {
    T1190: ['Exploit Public-Facing Application', 'Initial Access'],
    T1078: ['Valid Accounts', 'Initial Access'],
    T1059: ['Command and Scripting Interpreter', 'Execution'],
    T1053: ['Scheduled Task/Job', 'Persistence'],
    T1547: ['Boot or Logon Autostart Execution', 'Persistence'],
    T1098: ['Account Manipulation', 'Persistence'],
    T1548: ['Abuse Elevation Control Mechanism', 'Privilege Escalation'],
    T1055: ['Process Injection', 'Defense Evasion'],
    T1003: ['OS Credential Dumping', 'Credential Access'],
    T1046: ['Network Service Discovery', 'Discovery']
  };
  var TACTIC_ORDER = ['Initial Access', 'Execution', 'Persistence', 'Privilege Escalation', 'Defense Evasion', 'Credential Access', 'Discovery', 'Other'];

  function collectTechniques() {
    var found = {};
    $$('#work .project-item').forEach(function (c) {
      var seen = {};
      (c.textContent.match(/\bT1\d{3}(?:\.\d{3})?\b/g) || []).forEach(function (id) {
        var base = id.split('.')[0];
        if (seen[base]) return;
        seen[base] = true;
        found[base] = (found[base] || 0) + 1;
      });
    });
    var list = Object.keys(found).sort().map(function (id) { return { id: id, count: found[id] }; });
    return { list: list };
  }

  function initAttackExplorer() {
    var work = $('#work');
    if (!work || $('#attack-explorer')) return;
    var techs = collectTechniques().list;
    if (!techs.length) return;

    var sec = h('section');
    sec.id = 'attack-explorer';
    var head = h('div', 'section-header');
    var box = h('div');
    box.appendChild(h('h2', 'section-title', 'MITRE ATT&CK Coverage'));
    var sub = h('p', 'explorer-sub',
      'Techniques referenced across the projects below. Select one to filter the projects. ' +
      'Each technique is shown under its primary tactic; several map to more than one.');
    box.appendChild(sub);
    head.appendChild(box);
    sec.appendChild(head);

    var cols = {};
    techs.forEach(function (t) {
      var info = TECH[t.id];
      var tactic = info ? info[1] : 'Other';
      (cols[tactic] = cols[tactic] || []).push({ id: t.id, name: info ? info[0] : '', count: t.count });
    });
    var wrap = h('div', 'tactic-cols');
    TACTIC_ORDER.forEach(function (tactic) {
      if (!cols[tactic]) return;
      var col = h('div', 'tactic-col');
      col.appendChild(h('div', 'tactic-name', tactic));
      cols[tactic].forEach(function (t) {
        var b = h('button', 'tech');
        b.type = 'button';
        b.setAttribute('data-id', t.id);
        b.appendChild(h('b', null, t.id));
        if (t.name) b.appendChild(h('span', 'tech-name', t.name));
        b.appendChild(h('i', 'tech-count', t.count + (t.count === 1 ? ' project' : ' projects')));
        b.addEventListener('click', function () { setFilter({ type: 'tech', value: t.id }); });
        col.appendChild(b);
      });
      wrap.appendChild(col);
    });
    sec.appendChild(wrap);
    work.parentNode.insertBefore(sec, work);
  }

  function initReadMore() {
    $$('#work .project-desc, #flagship-labs .project-desc').forEach(function (p) {
      if (norm(p.textContent).length < 300 || p.getAttribute('data-rm')) return;
      p.setAttribute('data-rm', '1');
      p.classList.add('clamp');
      var b = h('button', 'read-more', 'Read more ▾');
      b.type = 'button';
      b.setAttribute('aria-expanded', 'false');
      b.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var open = p.classList.toggle('clamp') === false;
        b.textContent = open ? 'Show less ▴' : 'Read more ▾';
        b.setAttribute('aria-expanded', open ? 'true' : 'false');
      });
      p.parentNode.insertBefore(b, p.nextSibling);
    });
  }

  /* ------------------------------------------------------------------ */

  function init() {
    // order matters: explorer/tag chips first so reveal & stats see the final DOM
    initAttackExplorer();
    initTagFilters();
    initCounts();
    initReadMore();
    buildPalette();
    initStats();
    initSpotlight();
    initScrollSpy();
    initReveal();
  }

  if (doc.readyState === 'loading') doc.addEventListener('DOMContentLoaded', init);
  else init();
})();
