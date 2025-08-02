//
//  SettingsView.swift
//  Breathe
//
//  Created by Jan Bauer on 02.08.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("delaySeconds") var delaySeconds: Int = 2
    @AppStorage("appearanceMode") var appearanceMode: String = "system"
    @AppStorage("dailyLimitMinutes") var dailyLimitMinutes: Int = 5
    
    @AppStorage("intervalBlockEnabled") var intervalBlockEnabled: Bool = false
    @AppStorage("intervalMinutes") var intervalMinutes: Int = 5
    
    let delayOptions = Array(1...120)
    let limitOptions = Array(1...180)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    settingsCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Darstellung")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker(selection: $appearanceMode, label: EmptyView()) {
                                Label("System", systemImage: "circle.lefthalf.fill").tag("system")
                                Label("Hell", systemImage: "sun.max.fill").tag("light")
                                Label("Dunkel", systemImage: "moon.fill").tag("dark")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    settingsCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Verzögerung (Sekunden)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker("Sekunden", selection: $delaySeconds) {
                                ForEach(delayOptions, id: \.self) { second in
                                    Text("\(second) Sekunden").tag(second)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxHeight: 150)
                        }
                    }
                    
                    settingsCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tageslimit (Minuten)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker("Minuten", selection: $dailyLimitMinutes) {
                                ForEach(limitOptions, id: \.self) { minute in
                                    Text("\(minute) Minuten").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxHeight: 150)
                        }
                    }
                    
                    settingsCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Toggle("Intervall-Mathe-Sperre aktivieren", isOn: $intervalBlockEnabled)
                            
                            if intervalBlockEnabled {
                                Picker("Intervall (Minuten)", selection: $intervalMinutes) {
                                    ForEach(1...60, id: \.self) { min in
                                        Text("\(min) Min").tag(min)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxHeight: 120)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Einstellungen")
        }
    }
    
    @ViewBuilder
    private func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground)))
            .padding(.horizontal)
    }
}
