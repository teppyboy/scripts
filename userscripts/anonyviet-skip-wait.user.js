// ==UserScript==
// @name        Anonyviet.com skip wait page
// @namespace   tretrauit-dev
// @match       *://anonyviet.com/*
// @grant       none
// @version     1.0
// @author      tretrauit
// @description Skip the wait page that forces you to wait 15 seconds before redirecting to the destination page.
// @run-at      document-idle
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/anonyviet-skip-wait.user.js
// ==/UserScript==

const REDIRECT_PAGE = "https://anonyviet.com/tieptucdentrangmoi/?url="
for (const element of document.getElementsByTagName("a")) {
    try {
        if (element.getAttribute("href").startsWith(REDIRECT_PAGE)) {
            element.setAttribute("href", decodeURIComponent(element.getAttribute("href").substring(REDIRECT_PAGE.length)))
        }
    } catch (_) {
    }
}
