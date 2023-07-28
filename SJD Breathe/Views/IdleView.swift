//
//  IdleView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI

struct IdleView: View {
    
    @Environment(BreathingSessionController.self) var session
    @EnvironmentObject var appSettings: AppSettingsController
    
    @State var animationTrigger = false
    
    @State var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    @State var id = UUID()
    
    var body: some View {
        Text("Setup")
            .font(.title)
        
        BreathingIndicator(trigger: $animationTrigger)
            .id(id)
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: true) { timer in
                    animationTrigger.toggle()
                }
            }
            .onChange(of: appSettings.speed) { _, newValue in
                id = UUID()
                animationTrigger = false
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                    animationTrigger.toggle()
                    self.timer = Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: true) { timer in
                        animationTrigger.toggle()
                    }
                }
            }
        

        Form {
            Section() {
                Picker("Test", selection: $appSettings.speed) {
                    ForEach(BreathingSpeed.visibleCases, id: \.self) { speed in
                        Text("\(speed.label)").tag(speed)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Breathing speed")
                    .padding(.leading, 20)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowSpacing(0)
            .listRowBackground(EmptyView())

            Section("Number of breaths") {
                Stepper("\(appSettings.numberOfBreaths)", value: $appSettings.numberOfBreaths)
            }

            Section("Recovery time (seconds)") {
                Stepper("\(appSettings.recoveryTime)", value: $appSettings.recoveryTime)
            }
        }
        
    }
}

#Preview {
    VStack(spacing: 50) {
        IdleView()
    }
        .commonPreviewMods()
}
