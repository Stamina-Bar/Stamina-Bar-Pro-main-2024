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
    @EnvironmentObject var watchOSWorkoutManager: watchOSWorkoutManager
    @State private var showingSettings = false
    //    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    
    var workoutTypes: [WorkoutType] = [
        WorkoutType(workoutType: .tableTennis, workoutSupportingImage: "custom.StaminaBar")
        
    ]
    
    var body: some View {
        VStack {
            Spacer()
            if let workoutType = workoutTypes.first {
                NavigationLink(destination: SessionPagingView(),
                               tag: workoutType.workoutType,
                               selection: $watchOSWorkoutManager.selectedWorkout) {
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
                .sheet(isPresented: $showingSettings) {
                    SettingsView() // Settings view to show
                }
        }
        .onAppear {
            watchOSWorkoutManager.requestAuthorization()
        }
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
        case .tableTennis:
            return "Start Stamina Bar"
//        case .running:
//            return "Start Stamina Bar"
        default:
            return ""
        }
    }
}
