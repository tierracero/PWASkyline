var hasDefaultPropertiesItems = true
while (hasDefaultPropertiesItems) {
    let items = document.getElementsByName("default_theme_properties")
    if (items.length > 0) {
        for (var i = 0; i < items.length; i++ ) {
            items[i].remove();
        }
    }
    else {
        hasDefaultPropertiesItems = false
    }
}

function goToLogin(){
    window.location = `login`
}

(() => {
    const instances = window.__tcLoginMeshInstances || new Map()
    const pendingStarts = window.__tcLoginMeshPendingStarts || new Map()
    const libraryPromises = window.__tcLoginMeshLibraryPromises || new Map()

    window.__tcLoginMeshInstances = instances
    window.__tcLoginMeshPendingStarts = pendingStarts
    window.__tcLoginMeshLibraryPromises = libraryPromises

    const threeSource = "https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"
    const vantaSource = "https://cdn.jsdelivr.net/npm/vanta@0.5.24/dist/vanta.waves.min.js"

    function loadLibrary(name, source, isReady) {
        if (isReady()) return Promise.resolve()

        const pending = libraryPromises.get(name)
        if (pending) return pending

        const promise = new Promise((resolve, reject) => {
            const selector = `script[data-tc-login-mesh-library="${name}"]`
            let script = document.querySelector(selector)
            const isNewScript = !script

            const didLoad = () => {
                if (isReady()) {
                    resolve()
                    return
                }

                reject(new Error(`${name} loaded without exposing its browser API`))
            }

            const didFail = () => {
                reject(new Error(`Unable to load ${name}`))
            }

            if (!script) {
                script = document.createElement("script")
                script.src = source
                script.async = true
                script.dataset.tcLoginMeshLibrary = name
            }

            script.addEventListener("load", didLoad, { once: true })
            script.addEventListener("error", didFail, { once: true })

            if (isNewScript) {
                document.head.appendChild(script)
            }
        }).catch(error => {
            libraryPromises.delete(name)
            throw error
        })

        libraryPromises.set(name, promise)
        return promise
    }

    function ensureLibraries() {
        return loadLibrary("three-r134", threeSource, () => Boolean(window.THREE))
            .then(() => loadLibrary(
                "vanta-waves-0.5.24",
                vantaSource,
                () => Boolean(window.VANTA && typeof window.VANTA.WAVES === "function")
            ))
    }

    function stopLoginMeshEffect(elementId) {
        pendingStarts.delete(elementId)

        const instance = instances.get(elementId)
        if (!instance) return

        if (typeof instance.stopAmbientMotion === "function") {
            instance.stopAmbientMotion()
        }

        const effect = instance.effect || instance
        if (typeof effect.destroy === "function") {
            effect.destroy()
        }

        instances.delete(elementId)
    }

    function setLoginMeshEnabled(enabled) {
        const isEnabled = enabled !== false
        const settings = window.tcVisualPerformanceSettings || {}
        const wasEnabled = settings.loginMeshEnabled !== false

        settings.loginMeshEnabled = isEnabled
        window.tcVisualPerformanceSettings = settings

        if (!isEnabled) {
            pendingStarts.clear()
            Array.from(instances.keys()).forEach(stopLoginMeshEffect)
        }
        else if (!wasEnabled) {
            document
                .querySelectorAll(".tc-login-mesh-background[id]")
                .forEach(element => startLoginMeshEffect(element.id))
        }

        return isEnabled
    }

    function startAmbientMotion(effect) {
        const targetZoom = 1.452443967572723
        const initialZoom = targetZoom * 0.84
        const zoomDuration = 3200
        const idleDelay = 2200
        const startedAt = performance.now()
        let lastUserInputAt = startedAt - idleDelay
        let animationFrame = 0
        let appliedZoom = initialZoom

        const registerUserInput = () => {
            lastUserInputAt = performance.now()
        }

        const animate = now => {
            const elapsed = now - startedAt
            const zoomProgress = Math.min(elapsed / zoomDuration, 1)
            const easedZoomProgress = 1 - Math.pow(1 - zoomProgress, 3)
            const isIdle = now - lastUserInputAt > idleDelay
            const idleZoom = isIdle && zoomProgress === 1
                ? Math.sin(elapsed * 0.00045) * 0.018
                : 0
            const nextZoom = initialZoom
                + ((targetZoom - initialZoom) * easedZoomProgress)
                + idleZoom

            if (Math.abs(nextZoom - appliedZoom) > 0.0001) {
                appliedZoom = nextZoom
                effect.setOptions({ zoom: nextZoom })
            }

            if (isIdle && typeof effect.onMouseMove === "function") {
                const driftTime = elapsed / 1000
                const x = 0.5 + (Math.sin(driftTime * 0.32) * 0.035)
                const y = 0.5 + (Math.cos(driftTime * 0.27) * 0.022)
                effect.onMouseMove(x, y)
            }

            animationFrame = window.requestAnimationFrame(animate)
        }

        window.addEventListener("mousemove", registerUserInput, { passive: true })
        window.addEventListener("touchstart", registerUserInput, { passive: true })
        window.addEventListener("touchmove", registerUserInput, { passive: true })
        animationFrame = window.requestAnimationFrame(animate)

        return () => {
            window.cancelAnimationFrame(animationFrame)
            window.removeEventListener("mousemove", registerUserInput)
            window.removeEventListener("touchstart", registerUserInput)
            window.removeEventListener("touchmove", registerUserInput)
        }
    }

    function startLoginMeshEffect(elementId) {
        const element = document.getElementById(elementId)
        if (!(element instanceof HTMLElement)) return

        stopLoginMeshEffect(elementId)
        element.style.backgroundColor = "#1D2026"

        if (window.tcVisualPerformanceSettings?.loginMeshEnabled === false) {
            return
        }

        if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
            return
        }

        const request = Symbol(elementId)
        pendingStarts.set(elementId, request)

        ensureLibraries()
            .then(() => {
                if (pendingStarts.get(elementId) !== request || !element.isConnected) {
                    return
                }

                const effect = window.VANTA.WAVES({
                    el: element,
                    backgroundAlpha: 1,
                    backgroundColor: 0x1D2026,
                    color: 0x000000,
                    gyroControls: false,
                    minHeight: 200,
                    minWidth: 200,
                    mouseControls: true,
                    scale: 1,
                    scaleMobile: 1,
                    shininess: 24,
                    touchControls: true,
                    waveHeight: 2.5,
                    waveSpeed: 0.75,
                    zoom: 1.452443967572723 * 0.84
                })

                pendingStarts.delete(elementId)
                instances.set(elementId, {
                    effect,
                    stopAmbientMotion: startAmbientMotion(effect)
                })
            })
            .catch(error => {
                if (pendingStarts.get(elementId) === request) {
                    pendingStarts.delete(elementId)
                }

                console.error("Unable to start the login mesh background.", error)
            })
    }

    window.startLoginMeshEffect = startLoginMeshEffect
    window.stopLoginMeshEffect = stopLoginMeshEffect
    window.setLoginMeshEnabled = setLoginMeshEnabled

    setLoginMeshEnabled(
        window.tcVisualPerformanceSettings?.loginMeshEnabled !== false
    )
})()
