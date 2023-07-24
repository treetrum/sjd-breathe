//
//  AppSettingsController.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import Foundation
import Observation
import SwiftUI

enum BreathingSpeed: String, CaseIterable {
    case slow
    case regular
    case fast
    case xfast
    
    static let visibleCases: [BreathingSpeed] = [.slow, .regular, .fast]
    
    var label: String {
        switch self {
        case .slow:
            "Slow"
        case .regular:
            "Regular"
        case .fast:
            "Fast"
        case .xfast:
            "Extra Fast"
        }
    }
    
    var fullBreathDuration: Double {
        return switch self {
        case .slow:
            5
        case .regular:
            3.5
        case .fast:
            2
        case .xfast:
            1
        }
    }
    
    var halfBreathDuration: Double {
        return self.fullBreathDuration / 2
    }
    

}

class AppSettingsController: ObservableObject {
    
    static let shared = AppSettingsController()

    @AppStorage("number-of-breaths")
    var numberOfBreaths: Int = 30
    
    @AppStorage("breathing-speed")
    var speed: BreathingSpeed = .regular
    
    @AppStorage("recovery-time")
    var recoveryTime: Int = 15
    
}
