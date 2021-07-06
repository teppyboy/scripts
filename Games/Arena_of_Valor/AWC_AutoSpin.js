// Fetch jQuery
await fetch("https://code.jquery.com/jquery-3.6.0.min.js").then(x => x.text()).then(y => eval(y))
// Wait for jQuery to be loaded.
{
    // From https://stackoverflow.com/a/53914092
    class ClassWatcher {

        constructor(targetNode, classToWatch, classAddedCallback, classRemovedCallback) {
            this.targetNode = targetNode
            this.classToWatch = classToWatch
            this.classAddedCallback = classAddedCallback
            this.classRemovedCallback = classRemovedCallback
            this.observer = null
            this.lastClassState = targetNode.classList.contains(this.classToWatch)
    
            this.init()
        }
    
        init() {
            this.observer = new MutationObserver(this.mutationCallback)
            this.observe()
        }
    
        observe() {
            this.observer.observe(this.targetNode, { attributes: true })
        }
    
        disconnect() {
            this.observer.disconnect()
        }
    
        mutationCallback = mutationsList => {
            for(let mutation of mutationsList) {
                if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                    let currentClassState = mutation.target.classList.contains(this.classToWatch)
                    if(this.lastClassState !== currentClassState) {
                        this.lastClassState = currentClassState
                        if(currentClassState) {
                            this.classAddedCallback()
                        }
                        else {
                            this.classRemovedCallback()
                        }
                    }
                }
            }
        }
    }

    var disableChest = false
    function clickFirstButtonByClassName(className) {
        let btn = document.getElementsByClassName(className)[0]
        if (!(typeof btn === "undefined")) {
            btn.dispatchEvent(new MouseEvent("click"));
        }
    }
    // Click the spin button
    function spin() {
        clickFirstButtonByClassName("wheel__main--note")
        if (!disableChest) {
            clickFirstButtonByClassName("chest")
        }
    }

    function pickCard() {
        let teams = document.getElementsByClassName("popup-draw__card")
        for (let i = 0; i < 3; i++) {
            teams[i].dispatchEvent(new MouseEvent("click"));
        }
        setTimeout(() => jQuery(".ReactModal__Overlay").trigger("click"), 2000)
    }
    // Check for dialog message then close
    function closeSwalDialog() {
        clickFirstButtonByClassName("swal2-close")
        if (document.getElementsByClassName("swal2-close").length > 0) {
            setTimeout(closeSwalDialog, 100);
        }
    }

    function Swal2Dialog() {
        if (document.getElementsByClassName("popup-draw__card").length > 0) {
            pickCard()
        }
        else {
            let swal2msg = document.getElementsByClassName("popup-alert__message")
            if (swal2msg.length > 0) {
                console.log(swal2msg[0].innerHTML)
                if (swal2msg[0].innerHTML == "Đã đạt đến giới hạn Rương đếm ngược hàng ngày") {
                    disableChest = true
                }
                else if (swal2msg[0].innerHTML == "Bạn đã hết lượt quay trong ngày") {
                    closeAutoFarm()
                }
            }
        }
        closeSwalDialog()
    }
    
    // Watch for SweetAlert 2
    let swal2Watcher = new ClassWatcher(document.body, 'swal2-shown', Swal2Dialog, spin);

    function closeAutoFarm() {
        swal2Watcher.disconnect()
    }

    spin()
    // Disable window change
    jQuery("window").off("mouseup")
    jQuery("document").off("visibilitychange")
    // Remove video player (so it isnt annoying to me and save CPU by a lot)
    Array.from(document.getElementsByTagName("iframe")).forEach((iframe) => {
        iframe.remove()
    })
}
