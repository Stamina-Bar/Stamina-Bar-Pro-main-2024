//
//  Stamina_Bar_Apple_WatchApp.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import SwiftUI

@main
struct Stamina_Bar_Apple_Watch_Watch_AppApp: App {
        @StateObject private var workoutManager = WorkoutManager()
        
        @SceneBuilder var body: some Scene {
            WindowGroup {
                NavigationView {
                    StartView()
                }
                .sheet(isPresented: $workoutManager.showingSummaryView) {
                    SummaryView()
                }
                .environmentObject(workoutManager)
            }
        }
}
