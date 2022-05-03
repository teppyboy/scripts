// ==UserScript==
// @name        8thang5 - Auto farm
// @description Redirects Shorts to normal video webpage
// @namespace   tretrauit-dev
// @match       *://8thang5.lienquan.garena.vn/*
// @icon        https://cdn.vn.garenanow.com/web/kg/8thang5/img/favicon.jpg
// @grant       none
// @version     1.0.0
// @author      tretrauit
// @run-at      document-idle
// @homepageURL https://gitlab.com/tretrauit/scripts
// @supportURL  https://gitlab.com/tretrauit/scripts/-/issues
// @downloadURL https://gitlab.com/tretrauit/scripts/-/raw/main/userscripts/kgvn-8thang5-autofarm.user.js
// ==/UserScript==

function init() {
    const chest = document.getElementsByClassName("chest")[0]
    const chestStatus = document.getElementsByClassName("chest__btn btn")[0]
    const openWheelBtn = document.getElementsByClassName("wheel__btn")[0]
    const upgradeBtn = document.getElementsByClassName("card__upgrade")[0]
    // Has string characters need to be removed first.
    const requiredScore = document.getElementsByClassName("card__note")[0].getElementsByTagName("strong")[0]
    const currentScore = document.getElementsByClassName("card__data")[0].getElementsByTagName("span")[1]

    function toInt(str) {
        return parseInt(str.replace(/[^0-9]/g, ''))
    }

    function upgradeRank() {
        if (toInt(currentScore.innerHTML) >= toInt(requiredScore.innerHTML)) {
            upgradeBtn.click()
        }
    }

    function receiveRankReward() {
        const rewards = document.getElementsByClassName("milestone  available")
        for (const reward of rewards) {
            if (reward.className.includes("claimed")) {
                continue
            }
            reward.click()
        }
    }

    function spinWheel() {
        const spinBtn = document.getElementsByClassName("popup-wheel__btn")[0]
        const spinLeft = spinBtn.children[1].getElementsByTagName("strong")[0]
        function doSpin() {
            spinBtn.click()
            setTimeout(() => {
                if (parseInt(spinLeft.innerHTML) > 0) {
                    setTimeout(doSpin, 1000)
                }
            }, 3000)
        }
        doSpin()
        const closeBtn = document.getElementsByClassName("close")[0]
        closeBtn.click()
    }

    function wheel() {
        if (!openWheelBtn.className.includes("animate__tada") || document.getElementById("wheel") != null) {
            return
        }
        console.log("click chest")
        openWheelBtn.click()
        setTimeout(spinWheel, 1000)
    }

    function receiveScore() {
        if (chestStatus.innerHTML === "Nhận") {
            chest.click()
        }
    }

    setInterval(() => {
        if (element = document.getElementsByClassName("swal2-close")[0]) {
            element.click()
        }
    }, 100);

    function loop() {
        receiveScore()
        upgradeRank()
        receiveRankReward()
        setTimeout(wheel, 500)
        setTimeout(loop, 1000)
    }
    loop()
}
setTimeout(init, 5000)

console.warn("[8thang5 - Auto farm] Successfully loaded")
console.log("Made by @tretrauit under MIT License")
