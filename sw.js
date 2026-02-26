/* Service Worker for Schoolsuite360
   - Precaches local app shell files and selected dependencies
   - Provides runtime caching for CDN-hosted libraries
   - Simple cache-first for precached assets, network-first for API calls
*/

const CACHE_PREFIX = 'ss360-v1';
const PRECACHE = `${CACHE_PREFIX}-precache`;
const RUNTIME = `${CACHE_PREFIX}-runtime`;

// List of local files to precache during install. Keep this list minimal so
// install doesn't block for too long. Additional CDN assets can be cached
// dynamically after the worker activates (see message handler below).
const PRECACHE_URLS = [
  '/',
  '/index.php',
  '/login.php',
  '/dist/css/adminlte.css',
  '/dist/js/adminlte.min.js',
  '/dist/js/skul.js',
  '/dist/js/assessment_image_buffer.js',
  '/dist/js/examination.js',
  '/plugins/jquery/jquery.min.js',
  '/plugins/bootstrap/js/bootstrap.bundle.min.js',
  '/plugins/toastr/toastr.min.js',
  '/plugins/moment/moment.min.js',
  '/plugins/daterangepicker/daterangepicker.js',
  '/uploads/company_logo.png'
];

// Common CDN files you may want to cache; these will be cached on-demand when
// a page (like `skul.js`) sends a message to the worker to precache them.
const COMMON_CDN_URLS = [
  'https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback',
  'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
  'https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css',
  'https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.css',
  'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.js'
];

self.addEventListener('install', event => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(PRECACHE)
      .then(cache => cache.addAll(PRECACHE_URLS))
  );
});

self.addEventListener('activate', event => {
  // Remove old caches
  const currentCaches = [PRECACHE, RUNTIME];
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.map(key => {
        if (!currentCaches.includes(key)) return caches.delete(key);
      })
    ))
    .then(() => self.clients.claim())
  );
});

// A basic fetch handler: serve precached assets first, then network. For API
// requests (detected by /api/ or .php endpoints), try network first and fall back to cache.
self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);

  // Only handle GET requests
  if (request.method !== 'GET') return;

  // Network-first for PHP/API endpoints
  if (url.pathname.endsWith('.php') || url.pathname.startsWith('/api/') || url.pathname.includes('/model/')) {
    event.respondWith(
      fetch(request).then(response => {
        // Optionally cache API responses if needed
        return response;
      }).catch(() => caches.match(request))
    );
    return;
  }

  // Cache-first for precached and static assets
  event.respondWith(
    caches.match(request).then(cachedResponse => {
      if (cachedResponse) return cachedResponse;

      return caches.open(RUNTIME).then(cache =>
        fetch(request).then(response => {
          // Cache responses (including opaque cross-origin responses).
          // Opaque responses have limited inspectability but are useful for
          // offline serving of CDN assets.
          if (response) {
            try { cache.put(request, response.clone()); } catch (e) { /* ignore */ }
          }
          return response;
        }).catch(() => {
          // Fallback to a generic offline response for navigation requests
          if (request.mode === 'navigate') {
            return caches.match('/index.php');
          }
        })
      );
    })
  );
});

// Optional: listen for messages to update the precache list or skipWaiting
self.addEventListener('message', event => {
  if (!event.data) return;

  // Ask the worker to skip waiting and activate immediately
  if (event.data === 'skipWaiting') return self.skipWaiting();

  // Dynamically precache a list of URLs (useful for CDN assets). Pages can
  // postMessage({type: 'precache', urls: [...]}) to instruct the worker.
  if (event.data.type === 'precache' && Array.isArray(event.data.urls)) {
    caches.open(PRECACHE).then(cache => {
      // Use Promise.allSettled so one failed resource doesn't block others
      return Promise.allSettled(event.data.urls.map(url => {
        // Use fetch with no-cors for cross-origin resources if needed
        return fetch(url, {mode: 'no-cors'}).then(resp => cache.put(url, resp)).catch(() => {});
      }));
    });
  }
});
