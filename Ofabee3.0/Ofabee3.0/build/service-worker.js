/**
 * Welcome to your Workbox-powered service worker!
 *
 * You'll need to register this file in your web app and you should
 * disable HTTP caching for this file too.
 * See https://goo.gl/nhQhGp
 *
 * The rest of the code is auto-generated. Please don't update this file
 * directly; instead, make changes to your Workbox build configuration
 * and re-run your build process.
 * See https://goo.gl/2aRDsh
 */

importScripts("https://storage.googleapis.com/workbox-cdn/releases/3.6.3/workbox-sw.js");

importScripts(
  "./precache-manifest.e556612732682d99876c8760eec07975.js"
);

workbox.clientsClaim();

/**
 * The workboxSW.precacheAndRoute() method efficiently caches and responds to
 * requests for URLs in the manifest.
 * See https://goo.gl/S9QRab
 */
self.__precacheManifest = [
  {
    "url": "./js/combined.min.js",
    "revision": "efd34fb0b4df912247a9ef5dd298c712"
  },
  {
    "url": "./css/flowplayer.css",
    "revision": "0030ee44d3f9aa5f489d0b48e33e4208"
  },
  {
    "url": "./css/icons/flowplayer.eot",
    "revision": "8b1c59b76bd680bb3bf1b759d32c9b35"
  },
  {
    "url": "./css/icons/flowplayer.svg",
    "revision": "2b083dde1b404ed5c1cf3284bd09a91d"
  },
  {
    "url": "./css/icons/flowplayer.ttf",
    "revision": "fb07e456c3e99eeebe9a2b9a3c7d7cfd"
  },
  {
    "url": "./css/icons/flowplayer.woff",
    "revision": "3055674f97ef1b295ba52ee8c457a71a"
  },
  {
    "url": "./css/icons/flowplayer.woff2",
    "revision": "73ccb97fd8df0703038a40b00dc8ae5f"
  }
].concat(self.__precacheManifest || []);
workbox.precaching.suppressWarnings();
workbox.precaching.precacheAndRoute(self.__precacheManifest, {});

workbox.routing.registerNavigationRoute("./index.html", {
  
  blacklist: [/^\/_/,/\/[^\/]+\.[^\/]+$/],
});
