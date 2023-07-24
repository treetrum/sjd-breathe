//
//  SJD_BreatheApp.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI

extension View {
    func commonPreviewMods(_ session: BreathingSessionController = BreathingSessionController()) -> some View {
        
        var settings = AppSettingsController()
        settings.numberOfBreaths = 3
        settings.speed = .xfast
        settings.recoveryTime = 3
        
        return self
            .environment(session)
            .environmentObject(AppSettingsController())
            
    }
}

struct SJDBreatheAppWindow: View {
    
    var breathingSessionController: BreathingSessionController = BreathingSessionController()
    
    var body: some View {
        ContentView()
            .environment(breathingSessionController)
    }
}

@main
struct SJDBreatheApp: App {
    
    @ObservedObject var appSettingsController: AppSettingsController = AppSettingsController()
    
    var body: some Scene {
        WindowGroup {
            SJDBreatheAppWindow()
                .environmentObject(appSettingsController)
        }
    }
}
