import SwiftUI

struct DeveloperSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("forceLimitReached") var forceLimitReached: Bool = false
    @AppStorage("totalUsageToday") var totalUsageToday: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Testfunktionen")) {
                    Toggle("Limit erzwingen", isOn: $forceLimitReached)
                }
                
                Section {
                    Button(role: .destructive) {
                        BreatheApp.resetAllUsageLimits()
                        totalUsageToday = 0 // Sofort im UI
                        forceLimitReached = false
                    } label: {
                        Text("Täglichen Nutzungszähler zurücksetzen")
                    }
                }
            }
            .navigationTitle("Dev Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
