const staticCacheName = 'site-static-v1';
const dynamicCacheName = 'site-dynamic-v1';

const assets = [
    '/',
    '/index.html',
    '/pages/fallback.html',
    '/css/style.css',
];

// install service worker listener
self.addEventListener('install', evt => {
    // evt.waitUntil(
    //     caches.open(staticCacheName).then((cache) => {
    //         console.log('caching shell assets');
    //         // cache.addAll(assets);
    //     })
    // );
});

// activate service worker listener
self.addEventListener('activate', evt => {
    // deleting old cache
    // evt.waitUntil(
    //     caches.keys().then(keys => {
    //         console.log(keys);
    //         return Promise.all(keys
    //             .filter(key => key !== staticCacheName && key !== dynamicCacheName)
    //             .map(key => caches.delete(key))
    //         )
    //     })
    // );
});

// fetch event listener
self.addEventListener('fetch', evt => {
    // if querying firebase should not cache
    // evt.respondWith(
    //     caches.match(evt.request).then((cacheRes) => {
    //         return cacheRes || fetch(evt.request).then((fetchRes) => {
    //             return caches.open(dynamicCacheName).then((cache) => {
    //                 cache.put(evt.request.url, fetchRes.clone());
    //                 limitCacheSize(dynamicCacheName, 10);
    //                 return fetchRes;
    //             })
    //         })
    //     }).catch(() => {
    //         if (evt.request.url.indexOf('.html') > -1) {
    //             return caches.match('/pages/fallback.html');
    //         }
    //     })
    // )
})