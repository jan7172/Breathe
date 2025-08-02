import SwiftUI

@main
struct BreatheApp: App {
    @State private var targetApp: SocialApp? = nil
    @State private var blockNextLaunch = false
    
    @AppStorage("habitProgress") var habitProgress: Int = 0
    @AppStorage("delaySeconds") var delaySeconds: Int = 2
    @AppStorage("appearanceMode") var appearanceMode: String = "system"
    @AppStorage("dailyLimitMinutes") var dailyLimitMinutes: Int = 5
    @AppStorage("totalUsageToday") var totalUsageToday: Int = 0
    @AppStorage("lastUsageReset") var lastUsageReset: Double = Date().timeIntervalSince1970
    @AppStorage("forceLimitReached") var forceLimitReached: Bool = false
    
    // Neue Intervall-Sperre
    @AppStorage("intervalBlockEnabled") var intervalBlockEnabled: Bool = false
    @AppStorage("intervalMinutes") var intervalMinutes: Int = 5
    @AppStorage("lastOpenTime") var lastOpenTime: Double = 0
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let app = targetApp {
                    PromptView(
                        app: app,
                        onCancel: {
                            habitProgress += 1
                            targetApp = nil
                        },
                        onConfirm: {
                            openTargetApp(app)
                            targetApp = nil
                        }
                    )
                } else {
                    MainView()
                }
            }
            .preferredColorScheme(getColorScheme())
            .onAppear {
                resetDailyUsageIfNeeded()
            }
            .onOpenURL { url in
                handleURL(url)
            }
        }
    }
    
    private func getColorScheme() -> ColorScheme? {
        switch appearanceMode {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
    
    private func handleURL(_ url: URL) {
        if blockNextLaunch { return }
        
        guard url.scheme == "breathe",
              url.host == "open",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItem = components.queryItems?.first(where: { $0.name == "app" }),
              let value = queryItem.value,
              let app = SocialApp(rawValue: value) else { return }
        
        let now = Date().timeIntervalSince1970
        
        if intervalBlockEnabled {
            let timeSinceLastOpen = now - lastOpenTime
            if timeSinceLastOpen < Double(intervalMinutes * 60) && lastOpenTime > 0 {
                // Noch innerhalb des Intervalls → normal öffnen
                openTargetApp(app)
                return
            }
        }
        
        // Zeit ist abgelaufen oder Intervall-Sperre aus → Aufgabe zeigen
        targetApp = app
    }
    
    private func openTargetApp(_ app: SocialApp) {
        blockNextLaunch = true
        totalUsageToday += 60
        saveDailyUsage()
        
        if intervalBlockEnabled {
            lastOpenTime = Date().timeIntervalSince1970
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = URL(string: app.urlScheme) {
                UIApplication.shared.open(url)
            }
            blockNextLaunch = false
        }
    }
    
    static func getAppOpenCount(for app: SocialApp) -> Int {
        UserDefaults.standard.integer(forKey: "openCount_\(app.rawValue)")
    }
    
    static func resetAllUsageLimits() {
        let defaults = UserDefaults.standard
        
        defaults.set(0, forKey: "totalUsageToday")
        defaults.set(Date().timeIntervalSince1970, forKey: "lastUsageReset")
        
        for app in SocialApp.allCases {
            defaults.set(0, forKey: "openCount_\(app.rawValue)")
            defaults.set(Date(), forKey: "lastReset_\(app.rawValue)")
        }
        
        defaults.synchronize()
    }
    
    private func saveDailyUsage() {
        UserDefaults.standard.set(totalUsageToday, forKey: "totalUsageToday")
    }
    
    private func resetDailyUsageIfNeeded() {
        let now = Date()
        let lastResetDate = Date(timeIntervalSince1970: lastUsageReset)
        
        if !Calendar.current.isDateInToday(lastResetDate) {
            totalUsageToday = 0
            lastUsageReset = now.timeIntervalSince1970
            saveDailyUsage()
        }
    }
}
