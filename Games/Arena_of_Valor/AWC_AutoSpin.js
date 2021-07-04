(async function() {
    // Fetch jQuery
    let jquery = await fetch("https://code.jquery.com/jquery-3.6.0.min.js").then(x => x.text()).then(y => eval(y))
    let meaningOfLife = false;
    async function waitForJQuery(){
        while (true) {
                if ($ != null){
                    $("window").off("mouseup")
                    return
                }
                await null; // prevents app from hanging
        }
    }
    waitForJQuery();
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
            document.getElementsByClassName(className)[0].dispatchEvent(new MouseEvent("click"));
        }
        // Click the spin button
        function spin() {
            if (document.getElementsByClassName("popup-draw__card").length > 0) {
                // Do pick random 3 cards instead of spin.
                let teams = document.getElementsByClassName("popup-draw__card")
                for (let i = 0; i < 3; i++) {
                    teams[i].dispatchEvent(new MouseEvent("click"));
                }
            }
            else {
                // Spin
                clickFirstButtonByClassName("wheel__main--note")
                if (!disableChest) {
                    clickFirstButtonByClassName("chest")
                }
                document.getElementById("widget2").dispatchEvent(new MouseEvent("click"));
            }
        }
        // Close the dialog
        function closeSwal2() {
            if (document.getElementsByClassName("popup-alert__message")[0].innerHTML == "Đã đạt đến giới hạn Rương đếm ngược hàng ngày") {
                disableChest = true
            }
            clickFirstButtonByClassName("swal2-close")
        }
        
        // Watch for SweetAlert 2
        new ClassWatcher(document.body, 'swal2-shown', closeSwal2, spin);
        spin()
    }
})();
