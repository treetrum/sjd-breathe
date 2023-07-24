//
//  BreathingView.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 24/7/2023.
//

import SwiftUI

struct BreathingView: View {
    
    @Environment(BreathingSessionController.self) var session
    @EnvironmentObject var appSettings: AppSettingsController
    
    var body: some View {
        Text("Breathe").font(.title)
        Circle()
            .stroke(Color.accentColor, lineWidth: BreathingIndicator.lineWidth)
            .foregroundStyle(.black.opacity(0))
            .frame(width: breathingIndicatorSize, height: breathingIndicatorSize)
            .overlay(content: {
                Circle()
                    .foregroundColor(Color.accentColor)
                    .foregroundStyle(.black.opacity(0))
                    .phaseAnimator([BreathingIndicator.minScale, BreathingIndicator.maxScale], trigger: session.breathingCount, content: { view, value in
                        view.scaleEffect(value)
                    }, animation: { _ in
                        .easeInOut(duration: appSettings.speed.halfBreathDuration)
                    })
            })
        Text("\(session.breathingCount)").font(.title)
    }
}

#Preview {
    VStack(spacing: 50) {
        BreathingView()
    }
        .commonPreviewMods()
}
