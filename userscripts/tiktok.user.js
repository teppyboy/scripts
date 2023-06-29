// ==UserScript==
// @name        TikTok+
// @namespace   tretrauit-dev
// @match       *://www.tiktok.com/*
// @grant       none
// @version     1.0
// @author      tretrauit
// @description TikTok utilities.
// @run-at      document-idle
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/tiktok.user.js
// ==/UserScript==

// Remove the "download app ads"
const dlClasses = ["tiktok-9er52i-DivCtaGuideWrapper", "tiktok-99ed1t-DivFooterGuide", "tiktok-txik7e-DivFloatButtonWrapper"]
setInterval(() => {
    for (const dlClass of dlClasses) {
        const element = document.getElementsByClassName(dlClass)[0]
        if (element === undefined) {
            continue
        }
        for (const childElm of element.children) {
            console.log(childElm)
            setTimeout(() => element.removeChild(childElm), 1)
        }
        element.style["height"] = "0px"
        element.style["padding"] = "0px"
        element.style["z-index"] = "-1"
    }
}, 50)