//
//  Stamina_Bar_ProApp.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/3/24.
//

import SwiftUI

@main
struct Stamina_Bar_ProApp: App {
    @StateObject private var workoutManager = WorkoutManager()

    var body: some Scene {
        WindowGroup {
            let mockWorkoutManager = WorkoutManager()
            // Create a ViewModel instance with the mock WorkoutManager
            let viewModel = ChatView.ViewModel(workoutManager: mockWorkoutManager)

            ChatView(viewModel: viewModel)
                .environmentObject(workoutManager)
        }
    }
}

