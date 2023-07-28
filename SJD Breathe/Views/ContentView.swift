//
//  ContentView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI
import Observation

let breathingIndicatorSize: CGFloat = 150

struct ContentView: View {
    
    @Environment(BreathingSessionController.self) var session
    @EnvironmentObject var appSettings: AppSettingsController
    
    @State var breathIn = false

    var body: some View {
        NavigationStack {
            VStack {
                
                Rectangle()
                    .foregroundColor(.white.opacity(0))
                    .frame(height: 50)
                
                VStack(spacing: 50) {
                    switch session.currentStep {
                    case .idle:
                        IdleView()
                    case .breathing:
                        BreathingView()
                    case .holding:
                        HoldingView()
                    case .recovering:
                        RecoveryView()
                    }
                }
                
                Spacer()

                VStack {
                    if session.currentStep == .idle {
                        Button {
                            session.startSession()
                        } label: {
                            Text("Start session")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    } else {
                        Button {
                            session.stopSession()
                        } label: {
                            Text("Stop session")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("Default") {
    return ContentView()
        .commonPreviewMods()
}

#Preview("Breathing") {
    var session = BreathingSessionController()
    session.startSession()
    return ContentView()
        .commonPreviewMods(session)
}

#Preview("Holding") {
    var session = BreathingSessionController()
    session.startHolding()
    return ContentView()
        .commonPreviewMods(session)
}

#Preview("Recovering") {
    var session = BreathingSessionController()
    session.stopHolding()
    return ContentView()
        .commonPreviewMods(session)
}
