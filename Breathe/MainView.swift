//
//  MainView.swift
//  Breathe
//
//  Created by Jan Bauer on 02.08.25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("habitProgress") private var habitProgress: Int = 0
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Breathe Habit Tracker")
                    .font(.largeTitle)
                    .padding(.top, 40)
                
                Text("Du hast \(habitProgress)× bewusst auf Social Media verzichtet.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}
