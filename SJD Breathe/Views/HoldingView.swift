//
//  HoldingView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI

struct HoldingView: View {
    
    @Environment(BreathingSessionController.self) var session
    @EnvironmentObject var appSettings: AppSettingsController
    
    @State var breathIn = false

    var body: some View {
        Text("Hold").font(.title)
        
        BreathingIndicator(trigger: $breathIn)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    self.breathIn = false
                    withAnimation(.easeInOut(duration: appSettings.speed.halfBreathDuration)) {
                        self.breathIn = true
                    }
                }
            }
        
        Text("\(session.secondsHeld)").font(.title)

        Button("Finish holding") {
            withAnimation(.easeInOut(duration: appSettings.speed.halfBreathDuration)) {
                self.breathIn = false
            }
            Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: false) { _ in
                session.stopHolding()
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

#Preview {
    VStack(spacing: 50) {
        HoldingView()
    }
        .commonPreviewMods()
}
