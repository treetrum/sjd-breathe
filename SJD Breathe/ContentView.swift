//
//  ContentView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI
import Observation

enum RecoveryAnimationPhase: CaseIterable {
    case breatheOut
    case breatheIn

    var scale: Double {
        switch self {
        case .breatheOut:
            0.9
        case .breatheIn:
            0.1
        }
    }
}

enum HoldingAnimationPhase: CaseIterable {
    case idle
    case breatheIn
    case breatheOut
}

struct ContentView: View {
    
    var session: BreathingSessionController = .init()
    @State var recoverAnimation = 0
    @State var isHolding = false
    
    init(session: BreathingSessionController = .init()) {
        self.session = session
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                switch session.currentStep {
                case .idle:
                    Text("Waiting to start")
                case .breathing:
                    
                    VStack {
                        Text("\(session.breathingCount)").font(.title)
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 2)
                            .foregroundStyle(.black.opacity(0))
                            .frame(width: 100, height: 100)
                            .overlay(content: {
                                Circle()
                                    .foregroundColor(Color.accentColor)
                                    .foregroundStyle(.black.opacity(0))
                                    .phaseAnimator([0.1, 0.9], trigger: session.breathingCount, content: { view, value in
                                        view.scaleEffect(value)
                                    }, animation: { _ in
                                        .easeInOut(duration: session.speed.rawValue/2)
                                    })
                            })
                    }
                case .holding:
                    VStack {
                        Text("\(session.secondsHeld)").font(.title)
                        
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 2)
                            .foregroundStyle(.black.opacity(0))
                            .frame(width: 100, height: 100)
                            .overlay(content: {
                                Circle()
                                    .foregroundColor(Color.accentColor)
                                    .foregroundStyle(.black.opacity(0))
                                    .scaleEffect(isHolding ? 0.9 : 0.1)
                            })
                            .onAppear {
                                self.isHolding = false
                                withAnimation(.easeInOut(duration: session.speed.rawValue/2)) {
                                    self.isHolding = true
                                }
                            }

                        Button("Finish holding") {
                            withAnimation(.easeInOut(duration: session.speed.rawValue/2)) {
                                self.isHolding = false
                            }
                            Timer.scheduledTimer(withTimeInterval: session.speed.rawValue/2, repeats: false) { _ in
                                session.stopHolding()
                            }
                        }.buttonStyle(.borderedProminent)
                    }
                case .recovering:
                    
                    VStack {
                        Text("\(session.secondsRecovering)").font(.title)

                        Circle()
                            .stroke(Color.accentColor, lineWidth: 2)
                            .foregroundStyle(.black.opacity(0))
                            .frame(width: 100, height: 100)
                            .overlay(content: {
                                Circle()
                                    .foregroundColor(Color.accentColor)
                                    .foregroundStyle(.black.opacity(0))
                                    .scaleEffect(isHolding ? 0.9 : 0.1)
                            })
                            .onAppear {
                                self.isHolding = false
                                withAnimation(.easeInOut(duration: session.speed.rawValue/2)) {
                                    self.isHolding = true
                                }
                            }
                            .onChange(of: session.secondsRecovering) { oldValue, newValue in
                                if newValue == 0 {
                                    withAnimation(.easeInOut(duration: session.speed.rawValue/2)) {
                                        self.isHolding = false
                                    }
                                    Timer.scheduledTimer(withTimeInterval: session.speed.rawValue/2, repeats: false) { _ in
                                        session.startSession()
                                    }
                                }
                            }
                    }
                }
            
                
            }
            .navigationTitle(session.currentStep.getLabel())
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Start session") {
                            session.startSession()
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Stop session") {
                            session.stopSession()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
            }
        }
        .padding()
    }
}

#Preview("Default") {
    let session = BreathingSessionController(numberOfBreaths: 5, speed: .xfast, recoveryTime: 3)
    session.currentStep = .idle
    return ContentView(session: session)
}

#Preview("Breathing") {
    let session = BreathingSessionController(numberOfBreaths: 5, speed: .xfast, recoveryTime: 5)
    session.startSession()
    return ContentView(session: session)
}

#Preview("Holding") {
    let session = BreathingSessionController(numberOfBreaths: 5, speed: .xfast, recoveryTime: 5)
    session.startHolding()
    return ContentView(session: session)
}

#Preview("Recovering") {
    let session = BreathingSessionController(numberOfBreaths: 5, speed: .xfast, recoveryTime: 5)
    session.stopHolding()
    return ContentView(session: session)
}
