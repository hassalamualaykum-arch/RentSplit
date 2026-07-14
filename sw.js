const CACHE = "rentsplit-v1";
const ASSETS = [
  "./","./index.html","./manifest.json","./icon-192.png","./icon-512.png",
  "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"
];
self.addEventListener("install", e => { e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS))); self.skipWaiting(); });
self.addEventListener("activate", e => { e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k))))); self.clients.claim(); });
self.addEventListener("fetch", e => {
  if (e.request.url.includes(".supabase.co")) return;
  e.respondWith(caches.match(e.request).then(hit => hit || fetch(e.request).then(res=>{
    if (e.request.method==="GET" && res.ok){ const c=res.clone(); caches.open(CACHE).then(x=>x.put(e.request,c)); }
    return res;
  }).catch(()=>caches.match("./index.html"))));
});
