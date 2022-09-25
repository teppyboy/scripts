// ==UserScript==
// @name        Wallpaper Mode
// @namespace   tretrauit-dev
// @match       *://genshin.hoyoverse.com/concert2022
// @icon        https://genshin.hoyoverse.com/favicon.ico
// @grant       none
// @version     1.0
// @author      tretrauit
// @description 01:10:46, 26/9/2022
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/genshin-concert2022-wallpaper-mode.user.js
// ==/UserScript==

setTimeout(() => {
  const header = document.querySelector(".src-components-common-TopBar-assets-__pc_---top---uiHfPh");
  if (header != null) {
    header.remove()
    console.log("Removed header")
  }
  setTimeout(() => {
    const watermark = document.querySelector(".src-components-pages-assets-__kv_---kv-slogan---IBwwuz.kv-slogan");
    if (watermark != null) {
      watermark.remove()
      console.log("Removed watermark")
    }
  }, 5000);
}, 5000);
