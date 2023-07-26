//
//  RecoveryView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI

struct RecoveryView: View {
    
    @Environment(BreathingSessionController.self) var session
    @EnvironmentObject var appSettings: AppSettingsController
    
    @State var breathIn = false

    var body: some View {
        Text("Recover").font(.title)
        BreathingIndicator(trigger: $breathIn)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    self.breathIn = false
                    withAnimation(.easeInOut(duration: appSettings.speed.halfBreathDuration)) {
                        self.breathIn = true
                    }
                }
            }
            .onChange(of: session.secondsRecovering) { oldValue, newValue in
                if newValue == 0 {
                    withAnimation(.easeInOut(duration: appSettings.speed.halfBreathDuration)) {
                        self.breathIn = false
                    }
                    Timer.scheduledTimer(withTimeInterval: appSettings.speed.halfBreathDuration, repeats: false) { _ in
                        session.startSession()
                    }
                }
            }
        
        Text("\(session.secondsRecovering)").font(.title)
    }
}

#Preview {
    VStack(spacing: 50) {
        RecoveryView()
    }
        .commonPreviewMods()
}
