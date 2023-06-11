// ==UserScript==
// @name        hidemy.name - Free export IP:Port button
// @namespace   Violentmonkey Scripts
// @match       *://hidemy.name/*/proxy-list/
// @grant       none
// @version     1.0
// @author      tretrauit
// @description Replace the IP:Port button with a free button that copy to clipboard
// @run-at      document-idle
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/hidemy.name-free-ipport-export.user.js
// ==/UserScript==

setTimeout(function() {
    const tblContent = document.getElementsByClassName("table_block")[0].getElementsByTagName("tbody")[0].children

    // Replace the export IP:Port button
    const btns = document.getElementsByClassName("export")[0]
    const exportBtn = btns.children[0]
    const fakeExportBtn = exportBtn.cloneNode(true)
    fakeExportBtn.removeAttribute("href")
    fakeExportBtn.addEventListener("click", () => {
        var proxyStr = ""
        for (let proxyContent of tblContent) {
            const proxyContentChildren = proxyContent.children
            const proxyIp = proxyContentChildren[0].innerHTML
            const proxyPort = proxyContentChildren[1].innerHTML
            proxyStr += proxyIp + ":" + proxyPort + "\n"
        }
        navigator.clipboard.writeText(proxyStr)
        alert("Copied IP:Port list to clipboard.")
    })
    exportBtn.remove()
    btns.prepend(fakeExportBtn)
}, 5000);
