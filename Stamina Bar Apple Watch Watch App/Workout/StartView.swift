//
//  StartView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//

import Foundation
import HealthKit
import SwiftUI

struct WorkoutType: Identifiable {
    var id: HKWorkoutActivityType {
        return workoutType
    }
    let workoutType: HKWorkoutActivityType
    let workoutSupportingImage: String
}

struct StartView: View {
        @EnvironmentObject var workoutManager: WorkoutManager
        @State private var showingSettings = false

        var workoutTypes: [WorkoutType] = [
            WorkoutType(workoutType: .walking, workoutSupportingImage: "custom.StaminaBar")
        ]
    var body: some View {
                VStack {
                    Spacer()
                    if let workoutType = workoutTypes.first {
                        NavigationLink(destination: SessionPagingView(),
                                       tag: workoutType.workoutType,
                                       selection: $workoutManager.selectedWorkout) {
                            HStack {
                                Text("Start any Exercise")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                                       .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.blue, lineWidth: 2))
                    }
        
        
        
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                        .frame(width: 60, height: 60)
        
        
                //                .background(Circle().fill(Color.white.opacity(0.1)))
                        .onTapGesture {
        
                                showingSettings = true
        
                        }
//                        .sheet(isPresented: $showingSettings) {
//                            SettingsView() // Settings view to show
//                        }
        
                }
                .onTapGesture {
                    workoutManager.requestAuthorization()
                    print("Heart Rate: \(workoutManager.heartRate)")
                    print("HRV: \(workoutManager.heartRateVariability)")
                    print("V02 Max: \(workoutManager.currentVO2Max)")
                    print("Calories: \(workoutManager.activeEnergy)")

                }
//                .modifier(ConditionalScrollIndicatorModifier(shouldHide: shouldShowOnboarding))
//                .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
//                    OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
//                })
    

    }
}


struct ConditionalScrollIndicatorModifier: ViewModifier {
    var shouldHide: Bool
    
    func body(content: Content) -> some View {
        if #available(watchOS 9.0, *) {
            return AnyView(content.scrollIndicators(shouldHide ? .hidden : .visible))
        } else {
            return AnyView(content)
        }
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .walking:
            return "Start Stamina Bar"
        default:
            return ""
        }
    }
}
