//
//  ControlsView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//

import Foundation
import SwiftUI

struct ControlsView: View {

    var body: some View {

            HelperControlsView()

    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(watchOSWorkoutManager())
    }
}


struct HelperControlsView: View {
    @EnvironmentObject var workoutManager: watchOSWorkoutManager

    var body: some View {
        VStack {
            workoutManager.running ? Text("Pause Workout") : Text("Start Workout")

            Spacer()
            HStack {
                VStack {
                    Button {
                        workoutManager.endWorkout()
                        HapticManager.stopHaptic()

                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                    .font(.title2)
                    Text("End")
                }
                VStack {
                    Button {
                        workoutManager.togglePause()

                        workoutManager.running ? HapticManager.startHaptic() : HapticManager.stopHaptic()

                    } label: {
                        Image(systemName: workoutManager.running ? "pause" : "play")
                    }
                    .tint(.yellow)
                    .font(.title2)
                    Text(workoutManager.running ? "Pause" : "Resume")
                }
            }
        }
    }
}
