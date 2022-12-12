// ==UserScript==
// @name        NoShorts for YouTube
// @description Redirects Shorts to normal video webpage
// @namespace   tretrauit-dev
// @match       *://*.youtube.com/*
// @exclude-match`*://music.youtube.com/*
// @icon        https://upload.wikimedia.org/wikipedia/commons/f/fc/Youtube_shorts_icon.svg
// @grant       none
// @version     1.3.0
// @author      tretrauit
// @require     https://raw.githubusercontent.com/naugtur/insertionQuery/master/insQ.min.js
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/yt-noshorts.user.js
// @run-at      document-start
// ==/UserScript==

const DEBUG = false;

function logDebug(...kwargs) {
  if (!DEBUG) {
    return;
  }
  console.log(...kwargs);
}

function getShortsId(videoPathName)
{
  const shortPath = videoPathName.split("/")
  return shortPath[shortPath.length - 1]
}

function redirectReplace() {
  window.location.replace("https://www.youtube.com/watch?v=" + getShortsId(window.location.pathname));
}

function checkCurrentURL()
{
  if (window.location.pathname.includes("/shorts/"))
  {
    logDebug("Shorts url detected, redirecting...");
    redirectReplace();
  }
}

// Should be run asap
checkCurrentURL();

function replaceHrefURL(element)
{
  if (element.href != null && element.href.includes("/shorts/"))
  {
    element.href = "/watch?v=" + getShortsId(element.href)
  }
}

function checkElements()
{
  insertionQ(':is(#video-title, #thumbnail) ').every(function(element) {
    replaceHrefURL(element);
  });
}

window.addEventListener('yt-navigate-finish', checkCurrentURL);
// Replace addEventListener with our sus one.
const o_addEventListener = window.addEventListener;
const o_shady_addEventListener = window.__shady_addEventListener;
function f_addEventListener(eventName, callback) {
  logDebug("Event listener added: ", eventName);
  function f_callback(event) {
    function cb_dbg() {
      if (event instanceof MouseEvent) {
        // Event flood in console
        return;
      } else if (event instanceof PointerEvent) {
        // Event flood in console
        return;
      } else if (event instanceof BeforeUnloadEvent) {
        // Event flood in console
        return;
      }
      logDebug("Event callback triggered: ", event, event.data);
      logDebug("Page url: ", window.location.href);
    }
    if (DEBUG) {
      cb_dbg();
    }
    if (event instanceof MessageEvent) {
      // This event is made by SponsorBlock not Youtube so by default it will not run.
      // But this can speed up the page navigation process so i'll just keep it.
      const data = event.data;
      if (data.type == 'navigation' && data.pageType == 'shorts') {
        if (data.videoID == undefined) {
          return;
        }
        logDebug("Thank you SponsorBlock for this event :3");
        logDebug("Navigating to video...");
        if (window.location.pathname.includes("/shorts/")) {
          window.location.replace("https://www.youtube.com/watch?v=" + data.videoID);
          return;
        }
        window.location.assign("https://www.youtube.com/watch?v=" + data.videoID);
        return;
      }
    }
    callback(event);
  }
  o_addEventListener(eventName, f_callback);
}
function f_sus_addEventListener(a, b, c) {
  logDebug("Shady addEventListener triggered.");
  logDebug(a, b, c);
  o_shady_addEventListener(a, b, c);
}
window.addEventListener = f_addEventListener;
logDebug("Init fake addEventListener successful.");
window.__shady_addEventListener = f_sus_addEventListener;
logDebug("Init fake __shady_addEventListener successful.");
checkElements();
console.warn("Fuck you YouTube - NoShorts loaded.")
