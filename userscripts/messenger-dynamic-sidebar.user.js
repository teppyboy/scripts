// ==UserScript==
// @name        Dynamic Sidebar
// @namespace   tretrauit-dev
// @match       *://www.messenger.com
// @icon        https://genshin.hoyoverse.com/favicon.ico
// @grant       none
// @version     1.0
// @author      tretrauit
// @description Dynamic Sidebar for Facebook Messenger (messenger.com)
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/messenger-dynamic-sidebar.user.js
// ==/UserScript==

function injectCSS(css) {
  const style = document.createElement('style');
  style.appendChild(document.createTextNode(css));
  document.head.appendChild(style);
}

function findElement(tag, properties) {
    const elements = document.querySelectorAll(tag);
    elementLoop:
    for (const element of elements) {
        for (const [key, value] of Object.entries(properties)) {
            if (element.getAttribute(key) != value) {
                continue elementLoop;
            }
        }
        return element;
    }
}

function getAncestor(element, level) {
    for (let i = 0; i < level; i++) {
        element = element.parentNode;
    }
    return element;
}

console.log("Scanning class for components...");
let searchBox = findElement("input", {"aria-autocomplete": "list"});
if (searchBox != null) {
    searchBox = getAncestor(searchBox, 7);
}
let textHeader = findElement("span", {"style": "line-height: 28px;"});
let header;
if (textHeader != null) {
    header = getAncestor(textHeader, 7);
    textHeader = textHeader.childNodes[0];
}
let unreadIndicator = findElement("span", {"data-visualcompletion": "ignore"});
let actionBar = findElement("div", {"aria-expanded": "false"});
if (actionBar != null) {
    actionBar = actionBar.parentNode;
}
let chats = findElement("div", {"aria-label": "Chats"});
if (chats != null) {
    chats = chats.parentNode;
}

console.log("Search box:", searchBox);
console.log("Header:", header);
console.log("Text header:", textHeader);
console.log("Unread message indicator:", unreadIndicator);
console.log("Action bar:", actionBar);
console.log("Chat tab:", chats);