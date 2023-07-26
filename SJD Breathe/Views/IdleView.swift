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
    
    var body: some View {
        Text("Breathing speed")
            .font(.title)
        
        BreathingIndicator(trigger: $animationTrigger)
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: true) { timer in
                    animationTrigger.toggle()
                }
            }.onChange(of: appSettings.speed) { _, newValue in
                self.timer = Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: true) { timer in
                    animationTrigger.toggle()
                }
            }
        
        Picker("Test", selection: $appSettings.speed) {
            ForEach(BreathingSpeed.visibleCases, id: \.self) { speed in
                Text("\(speed.label)").tag(speed)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 50) {
        IdleView()
    }
        .commonPreviewMods()
}
