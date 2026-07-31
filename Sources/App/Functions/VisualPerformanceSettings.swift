//
//  VisualPerformanceSettings.swift
//

import JavaScriptKit

/// Runtime switches for visually expensive effects.
///
/// Every option defaults to `true`, preserving the existing presentation.
/// Call `apply()` after the browser scripts load, or change any option at
/// runtime to immediately update the current document.
enum VisualPerformanceSettings {

    private static var isApplyingBatch = false
    private static var didLoadPersistedPerformanceMode = false

    static var backdropFiltersEnabled = true {
        didSet { settingDidChange() }
    }

    static var modalBackdropBlurEnabled = true {
        didSet { settingDidChange() }
    }

    static var animatedBlurEnabled = true {
        didSet { settingDidChange() }
    }

    static var loginMeshEnabled = true {
        didSet { settingDidChange() }
    }

    static var dashboardStartupAnimationsEnabled = true {
        didSet { settingDidChange() }
    }

    /// The disabled state removes box shadows globally. CSS cannot reliably
    /// select shadows by blur radius, so this is intentionally a coarse test.
    static var largeShadowsEnabled = true {
        didSet { settingDidChange() }
    }

    /// Kept separate from the general performance mode because disabling the
    /// crop shade intentionally changes the editing affordance.
    static var cropperShadeEnabled = true {
        didSet { settingDidChange() }
    }

    /// Convenience switch for the expensive application-wide effects.
    /// Cropper shading remains enabled unless changed explicitly.
    static var performanceModeEnabled: Bool {
        get {
            loadPersistedPerformanceModeIfNeeded()

            return !backdropFiltersEnabled &&
            !modalBackdropBlurEnabled &&
            !animatedBlurEnabled &&
            !loginMeshEnabled &&
            !dashboardStartupAnimationsEnabled &&
            !largeShadowsEnabled
        }
        set {
            didLoadPersistedPerformanceMode = true
            isApplyingBatch = true

            backdropFiltersEnabled = !newValue
            modalBackdropBlurEnabled = !newValue
            animatedBlurEnabled = !newValue
            loginMeshEnabled = !newValue
            dashboardStartupAnimationsEnabled = !newValue
            largeShadowsEnabled = !newValue

            isApplyingBatch = false

            if let setter = JSObject.global.setPerformanceModeEnabled.function {
                _ = setter.callAsFunction(newValue)
            }
            else {
                apply()
            }
        }
    }

    static func apply() {
        loadPersistedPerformanceModeIfNeeded()

        _ = JSObject.global.setVisualPerformanceEffects.function?
            .callAsFunction(
                backdropFiltersEnabled,
                modalBackdropBlurEnabled,
                animatedBlurEnabled,
                loginMeshEnabled,
                dashboardStartupAnimationsEnabled,
                largeShadowsEnabled,
                cropperShadeEnabled
            )

        // These optional direct calls also cover pages where only one of the
        // feature-specific scripts has loaded.
        _ = JSObject.global.setLoginMeshEnabled.function?
            .callAsFunction(loginMeshEnabled)

        _ = JSObject.global.setCropperShadeEnabled.function?
            .callAsFunction(cropperShadeEnabled)
    }

    static func persistedPerformanceModeEnabled() -> Bool {
        loadPersistedPerformanceModeIfNeeded()
        return performanceModeEnabled
    }

    private static func loadPersistedPerformanceModeIfNeeded() {
        guard !didLoadPersistedPerformanceMode else { return }
        guard let getter = JSObject.global.getPerformanceModeEnabled.function else {
            return
        }
        guard let persistedValue = getter.callAsFunction().boolean else {
            return
        }

        didLoadPersistedPerformanceMode = true
        isApplyingBatch = true

        backdropFiltersEnabled = !persistedValue
        modalBackdropBlurEnabled = !persistedValue
        animatedBlurEnabled = !persistedValue
        loginMeshEnabled = !persistedValue
        dashboardStartupAnimationsEnabled = !persistedValue
        largeShadowsEnabled = !persistedValue

        isApplyingBatch = false
    }

    private static func settingDidChange() {
        guard !isApplyingBatch else { return }
        apply()
    }
}
