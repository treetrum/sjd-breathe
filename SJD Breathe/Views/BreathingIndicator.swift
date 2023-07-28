//
//  BreathingIndicator.swift
//  SJD Breathe
//
//  Created by Samuel Davis on 28/7/2023.
//

import SwiftUI

private struct AnimationValues {
    var scale: Double = 1.0
    var opacity: Double = 0.0
}

struct BreathingIndicator: View {
    static let size: CGFloat = 100
    static let lineWidth: CGFloat = 5
    static let minScale = 0.1
    static let maxScale = 0.9
    
    @EnvironmentObject var appSettings: AppSettingsController
    
    @Binding var trigger: Bool
    
    @State var pulseTrigger = 0
    @State var oppositePulseTrigger = 0
    
    var body: some View {
        Circle()
            .stroke(Color.accentColor, lineWidth: BreathingIndicator.lineWidth)
            .foregroundStyle(.black.opacity(0))
            .overlay {
            
                Circle()
                    .foregroundColor(Color.accentColor)
                    .keyframeAnimator(initialValue: AnimationValues(), trigger: pulseTrigger, content: { view, value in
                        view
                            .scaleEffect(value.scale)
                            .opacity(value.opacity)
                    }, keyframes: { value in
                        KeyframeTrack(\.scale) {
                            MoveKeyframe(1)
                            LinearKeyframe(1.5, duration: 0.5)
                            LinearKeyframe(1, duration: appSettings.speed.halfBreathDuration - 0.5)
                        }
                        KeyframeTrack(\.opacity) {
                            MoveKeyframe(0.5)
                            LinearKeyframe(0, duration: 0.5)
                            LinearKeyframe(0, duration: appSettings.speed.halfBreathDuration - 0.5)
                        }
                    })
                
                Circle()
                    .foregroundColor(Color.accentColor)
                    .scaleEffect(trigger ? BreathingIndicator.maxScale : BreathingIndicator.minScale)
                    .animation(.easeInOut(duration: appSettings.speed.halfBreathDuration), value: trigger)
                                    
            }
            .frame(width: breathingIndicatorSize, height: breathingIndicatorSize)
            .onChange(of: trigger) { oldValue, newValue in
                if oldValue == true {
                    pulseTrigger += 1
                } else {
                    oppositePulseTrigger += 1
                }
            }
    }
}

struct BreathingIndicatorPreview: View {
    @State var trigger: Bool = false
    
    @State var timer: Timer? {
        willSet {
            self.timer?.invalidate()
        }
    }

    var body: some View {
        BreathingIndicator(trigger: $trigger)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: AppSettingsController.shared.speed.halfBreathDuration, repeats: true) { timer in
                    trigger.toggle()
                }
            }
    }
}


#Preview {
    BreathingIndicatorPreview()
        .commonPreviewMods()
}

