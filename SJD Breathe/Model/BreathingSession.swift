//
//  BreathingSession.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import Foundation
import Observation

enum BreathingSpeed: Double {
    case slow = 6
    case regular = 3.5
    case fast = 2
    case xfast = 1
}

enum BreathingSessionStep {
    case idle
    case breathing
    case holding
    case recovering
    
    func getLabel() -> String {
        return switch self {
        case .idle:
            "SJD Breathing"
        case .breathing:
            "Breathing"
        case .holding:
            "Holding"
        case .recovering:
            "Recovering"
        }
    }
}

@Observable class BreathingSession {
    
    let numberOfBreaths: Int
    let speed: BreathingSpeed
    let recoveryTime: Double
    
    init(numberOfBreaths: Int = 30, speed: BreathingSpeed = .regular, recoveryTime: Double = 15) {
        self.numberOfBreaths = numberOfBreaths
        self.speed = speed
        self.recoveryTime = recoveryTime
    }

    var currentStep: BreathingSessionStep = .idle
    
    var breathingCount: Int = 0
    var secondsHeld: Int = 0
    var secondsRecovering: Int = 0
    
    var breathingTimer: Timer?
    var recoveryTimer: Timer?
    var holdingTimer: Timer?
    
    func startSession() {
        startBreathing()
    }
    
    private func startBreathing() {
        clearTimers()
        currentStep = .breathing
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { _ in
            self.breathingCount = self.numberOfBreaths

            self.breathingTimer = Timer.scheduledTimer(withTimeInterval: self.speed.rawValue, repeats: true) { timer in
                self.breathingCount -= 1
                if self.breathingCount == 0 {
                    timer.invalidate()
                    self.startHolding()
                }
            }
        }
        
    }
    
    func startHolding() {
        currentStep = .holding
        self.secondsHeld = 0
        self.holdingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.secondsHeld += 1
        })
    }
    
    func stopHolding() {
        holdingTimer?.invalidate()
        currentStep = .recovering
        self.secondsRecovering = Int(self.recoveryTime)
        
        self.recoveryTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.secondsRecovering -= 1
            if (self.secondsRecovering <= 0) {
                timer.invalidate()
            }
        })
    }
    
    func stopSession() {
        self.clearTimers()
        self.currentStep = .idle
    }
    
    private func clearTimers() {
        self.breathingTimer?.invalidate()
        self.recoveryTimer?.invalidate()
        self.holdingTimer?.invalidate()
    }
}
