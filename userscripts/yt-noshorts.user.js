// ==UserScript==
// @name        NoShorts for YouTube
// @description Redirects Shorts to normal video webpage
// @namespace   tretrauit-dev
// @match       *://*.youtube.com/*
// @exclude-match`*://music.youtube.com/*
// @icon        https://upload.wikimedia.org/wikipedia/commons/f/fc/Youtube_shorts_icon.svg
// @grant       none
// @version     1.2.1
// @author      tretrauit
// @description 22:36:53, 18/3/2022
// @require     https://raw.githubusercontent.com/naugtur/insertionQuery/master/insQ.min.js
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/yt-noshorts.user.js
// ==/UserScript==

function getShortsId(videoPathname)
{
  const shortPath = videoPathname.split("/")
  return shortPath[shortPath.length - 1]
}

function redirect() 
{
  window.location.replace("https://www.youtube.com/watch?v=" + getShortsId(window.location.pathname)) 
}

function replaceHrefURL(element)
{
  if (element.href.includes("/shorts/"))
  {
    element.href = "/watch?v=" + getShortsId(element.href)
  }
}

function checkCurrentURL()
{
  if (window.location.pathname.includes("/shorts/"))
  {
    redirect()
  }
}

function checkElements()
{
  insertionQ(':is(#video-title, #thumbnail) ').every(function(element){
    replaceHrefURL(element)
  });
}

window.addEventListener('yt-navigate-finish', checkCurrentURL)
checkCurrentURL()
checkElements()
console.log("Fuck you YouTube - NoShorts loaded.")
