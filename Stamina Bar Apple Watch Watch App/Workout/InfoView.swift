//
//  InfoView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//


import Foundation
import HealthKit
import SwiftUI

struct InfoView: View {
    @EnvironmentObject var workoutManager: watchOSWorkoutManager
    @State private var showSwipeInstruction = true
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = true

    @State private var showingSettings = false // State to control settings view presentation

    let staminaBarView = StaminaBarView()

    var body: some View {
        TimelineView(InfoViewTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
            VStack (alignment: .trailing) {
                if workoutManager.running {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: true)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                }
                (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
            }
        }
    }
}




struct InfoViewView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView().environmentObject(watchOSWorkoutManager())
    }
}

// Workout builder helper
private struct InfoViewTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)

        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }

}

