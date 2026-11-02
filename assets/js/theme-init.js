/* Calm theme bootstrap: pick the saved theme, else follow the device setting. Runs in <head> to avoid a flash. */
(function () {
  var root = document.documentElement, KEY = "portfolio-theme", saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  var mq = window.matchMedia ? matchMedia("(prefers-color-scheme: light)") : null;
  function system() { return mq && mq.matches ? "light" : "dark"; }
  root.setAttribute("data-theme", saved === "light" || saved === "dark" ? saved : system());
  /* follow the device until the visitor picks a theme themselves */
  if (mq && mq.addEventListener) mq.addEventListener("change", function () {
    var s = null; try { s = localStorage.getItem(KEY); } catch (e) {}
    if (s !== "light" && s !== "dark") root.setAttribute("data-theme", system());
  });
  /* remember a manual choice (any page's toggle just flips data-theme) */
  var first = true;
  new MutationObserver(function () {
    if (first) { first = false; }
    var t = root.getAttribute("data-theme");
    if (t === "light" || t === "dark") { try { localStorage.setItem(KEY, t); } catch (e) {} }
  }).observe(root, { attributes: true, attributeFilter: ["data-theme"] });
})();
