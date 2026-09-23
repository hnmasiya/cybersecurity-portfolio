(function(){
  const root=document.documentElement;
  const saved=localStorage.getItem("portfolio-theme");
  if(saved==="light"||saved==="dark") root.dataset.theme=saved;
  const btn=document.querySelector("[data-theme-toggle]");
  function sync(){if(btn) btn.textContent=root.dataset.theme==="light"?"☾ Dark":"☀ Light";}
  btn&&btn.addEventListener("click",function(){const next=root.dataset.theme==="light"?"dark":"light";root.dataset.theme=next;localStorage.setItem("portfolio-theme",next);sync()});
  sync();
  const bar=document.querySelector(".progress");
  function progress(){if(!bar)return;const max=document.documentElement.scrollHeight-innerHeight;bar.style.width=(max>0?(scrollY/max)*100:0)+"%";}
  addEventListener("scroll",progress,{passive:true});progress();
})();