import SwiftUI

struct ContentView: View {
    var app: SocialApp
    var delaySeconds: Int
    var dailyLimitMinutes: Int
    var forceLimitReached: Bool
    var onAppOpen: () -> Void
    
    @AppStorage("totalUsageToday") private var totalUsageToday: Int = 0
    @State private var remainingTime: Int = 0
    @State private var openCount: Int = 0
    
    var limitReached: Bool {
        forceLimitReached || totalUsageToday >= dailyLimitMinutes * 60
    }
    
    var body: some View {
        ZStack {
            app.color.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Du hast \(app.displayName) in den letzten 24 h \(openCount)× geöffnet.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if limitReached {
                    Text("Tageslimit von \(dailyLimitMinutes) Min erreicht")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                } else {
                    Text("\(app.displayName) öffnen?")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                
                Button(action: {
                    if remainingTime <= 0 && !limitReached {
                        onAppOpen()
                    }
                }) {
                    Text(limitReached ? "Blockiert" :
                         remainingTime > 0 ? "\(remainingTime) Sekunden warten…" :
                         "\(app.displayName) öffnen")
                        .font(.title2)
                        .padding()
                        .background(Color.white.opacity(limitReached ? 0.05 : (remainingTime > 0 ? 0.1 : 0.2)))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
                .disabled(limitReached || remainingTime > 0)
            }
        }
        .onAppear {
            startCountdown()
            openCount = BreatheApp.getAppOpenCount(for: app)
        }
    }
    
    private func startCountdown() {
        remainingTime = delaySeconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}
