(() => {
    if (window.__tcVisualPerformanceControllerInstalled) {
        return
    }

    window.__tcVisualPerformanceControllerInstalled = true

    const performanceModeCookieName = "tcPerformanceModeEnabled"

    function readCookie(name) {
        const prefix = `${encodeURIComponent(name)}=`
        const item = document.cookie
            .split(";")
            .map(value => value.trim())
            .find(value => value.startsWith(prefix))

        if (!item) {
            return null
        }

        return decodeURIComponent(item.slice(prefix.length))
    }

    function writePersistentCookie(name, value) {
        document.cookie = [
            `${encodeURIComponent(name)}=${encodeURIComponent(value)}`,
            "Expires=Fri, 31 Dec 9999 23:59:59 GMT",
            "Max-Age=2147483647",
            "Path=/",
            "SameSite=Lax",
        ].join("; ")
    }

    const persistedPerformanceModeEnabled =
        readCookie(performanceModeCookieName) === "true"

    const effectsEnabledByDefault = !persistedPerformanceModeEnabled

    const defaults = {
        backdropFiltersEnabled: effectsEnabledByDefault,
        modalBackdropBlurEnabled: effectsEnabledByDefault,
        animatedBlurEnabled: effectsEnabledByDefault,
        loginMeshEnabled: effectsEnabledByDefault,
        dashboardStartupAnimationsEnabled: effectsEnabledByDefault,
        largeShadowsEnabled: effectsEnabledByDefault,
        cropperShadeEnabled: true,
        performanceModeEnabled: persistedPerformanceModeEnabled,
    }

    const settings = Object.assign(
        defaults,
        window.tcVisualPerformanceSettings || {}
    )

    window.tcVisualPerformanceSettings = settings

    function ensureOverrideStyles() {
        if (document.getElementById("tc-visual-performance-overrides")) {
            return
        }

        const style = document.createElement("style")
        style.id = "tc-visual-performance-overrides"
        // Repeated root attributes deliberately outrank scoped theme rules
        // that already use `!important`.
        style.textContent = `
html[data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"] body *,
html[data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"] body *::before,
html[data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"][data-tc-backdrop-filters="off"] body *::after {
    backdrop-filter: none !important;
    -webkit-backdrop-filter: none !important;
}

html[data-tc-modal-backdrop-blur="off"] [data-add-to-dom-super-view="true"] {
    backdrop-filter: none !important;
    -webkit-backdrop-filter: none !important;
}

html[data-tc-animated-blur="off"] .tc-work-dashboard.tc-work-starting .tc-work-background,
html[data-tc-animated-blur="off"] .tc-work-dashboard.tc-work-starting .tc-work-workspace,
html[data-tc-animated-blur="off"] .tc-login-mesh-page.tc-login-handoff .tc-login-content-layer,
html[data-tc-animated-blur="off"] .tc-login-mesh-page.tc-login-handoff .tc-login-main-root,
html[data-tc-animated-blur="off"] .tc-login-mesh-page.tc-login-handoff .tc-login-mesh-background canvas {
    filter: none !important;
}

html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting * {
    animation: none !important;
    transition: none !important;
}

html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-background,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-top-bar,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-left-rail,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-messages,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-workspace,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-order-column,
html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard.tc-work-starting .tc-work-stat-card {
    opacity: 1 !important;
    transform: none !important;
    filter: none !important;
}

html[data-tc-dashboard-startup-animations="off"] .tc-work-dashboard .tc-work-startup-overlay {
    display: none !important;
}

html[data-tc-large-shadows="off"][data-tc-large-shadows="off"][data-tc-large-shadows="off"][data-tc-large-shadows="off"][data-tc-large-shadows="off"][data-tc-large-shadows="off"] body * {
    box-shadow: none !important;
}
`

        document.head.appendChild(style)
    }

    function setBooleanAttribute(name, enabled) {
        document.documentElement.setAttribute(name, enabled ? "on" : "off")
    }

    function applyVisualPerformanceSettings(
        backdropFiltersEnabled = true,
        modalBackdropBlurEnabled = true,
        animatedBlurEnabled = true,
        loginMeshEnabled = true,
        dashboardStartupAnimationsEnabled = true,
        largeShadowsEnabled = true,
        cropperShadeEnabled = true
    ) {
        settings.backdropFiltersEnabled = backdropFiltersEnabled !== false
        settings.modalBackdropBlurEnabled = modalBackdropBlurEnabled !== false
        settings.animatedBlurEnabled = animatedBlurEnabled !== false
        settings.loginMeshEnabled = loginMeshEnabled !== false
        settings.dashboardStartupAnimationsEnabled = dashboardStartupAnimationsEnabled !== false
        settings.largeShadowsEnabled = largeShadowsEnabled !== false
        settings.cropperShadeEnabled = cropperShadeEnabled !== false
        settings.performanceModeEnabled =
            !settings.backdropFiltersEnabled &&
            !settings.modalBackdropBlurEnabled &&
            !settings.animatedBlurEnabled &&
            !settings.loginMeshEnabled &&
            !settings.dashboardStartupAnimationsEnabled &&
            !settings.largeShadowsEnabled

        ensureOverrideStyles()

        setBooleanAttribute(
            "data-tc-backdrop-filters",
            settings.backdropFiltersEnabled
        )
        setBooleanAttribute(
            "data-tc-modal-backdrop-blur",
            settings.modalBackdropBlurEnabled
        )
        setBooleanAttribute(
            "data-tc-animated-blur",
            settings.animatedBlurEnabled
        )
        setBooleanAttribute(
            "data-tc-dashboard-startup-animations",
            settings.dashboardStartupAnimationsEnabled
        )
        setBooleanAttribute(
            "data-tc-large-shadows",
            settings.largeShadowsEnabled
        )

        document.documentElement.style.setProperty(
            "--tc-login-card-backdrop-filter",
            settings.backdropFiltersEnabled ? "blur(3px)" : "none"
        )

        if (typeof window.setLoginMeshEnabled === "function") {
            window.setLoginMeshEnabled(settings.loginMeshEnabled)
        }

        if (typeof window.setCropperShadeEnabled === "function") {
            window.setCropperShadeEnabled(settings.cropperShadeEnabled)
        }

        return Object.assign({}, settings)
    }

    window.setVisualPerformanceEffects = applyVisualPerformanceSettings
    window.getVisualPerformanceSettings = () => Object.assign({}, settings)
    window.getPerformanceModeEnabled = () => settings.performanceModeEnabled === true
    window.setPerformanceModeEnabled = enabled => {
        const performanceModeEnabled = enabled === true
        const effectsEnabled = !performanceModeEnabled

        writePersistentCookie(
            performanceModeCookieName,
            performanceModeEnabled ? "true" : "false"
        )

        return applyVisualPerformanceSettings(
            effectsEnabled,
            effectsEnabled,
            effectsEnabled,
            effectsEnabled,
            effectsEnabled,
            effectsEnabled,
            settings.cropperShadeEnabled
        )
    }

    applyVisualPerformanceSettings(
        settings.backdropFiltersEnabled,
        settings.modalBackdropBlurEnabled,
        settings.animatedBlurEnabled,
        settings.loginMeshEnabled,
        settings.dashboardStartupAnimationsEnabled,
        settings.largeShadowsEnabled,
        settings.cropperShadeEnabled
    )
})()
