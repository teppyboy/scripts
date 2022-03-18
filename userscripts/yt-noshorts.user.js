// ==UserScript==
// @name        NoShorts for YouTube
// @description Redirects Shorts to normal video webpage
// @namespace   tretrauit-dev
// @match       *://*.youtube.com/shorts/*
// @exclude-match`*://music.youtube.com/*
// @grant       none
// @version     1.1.1
// @author      tretrauit
// @description 22:36:53, 18/3/2022
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/yt-noshorts.user.js
// @noframes
// ==/UserScript==

console.log("Fuck you YouTube")
// Make sure our script won't die because const
{
  const shortPath = window.location.pathname.split("/")
  const shortId = shortPath[shortPath.length - 1]
  window.location.replace("https://www.youtube.com/watch?v=" + shortId) 
}
