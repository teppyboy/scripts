// ==UserScript==
// @name        NoShorts for YouTube
// @namespace   tretrauit-dev
// @match       https://www.youtube.com/shorts/*
// @grant       none
// @version     1.0
// @author      tretrauit
// @description 22:36:53, 18/3/2022
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @noframes
// ==/UserScript==

console.log("Fuck you YouTube")
// Make sure our script won't die because const
{
  const shortPath = window.location.pathname.split("/")
  const shortId = shortPath[shortPath.length - 1]
  window.location.replace("https://www.youtube.com/watch?v=" + shortId) 
}
