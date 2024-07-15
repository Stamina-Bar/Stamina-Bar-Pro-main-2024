//
//  HeartRateView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//

import SwiftUI
import HealthKit

struct HeartRateView: View {
    @EnvironmentObject var workoutManager: WorkoutManager



    let staminaBarView = StaminaBarView()

    var body: some View {
        TimelineView(HeartRateViewTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
            VStack (alignment: .trailing) {

                // TODO: Monitor if this fixes timer being shown in bug fix

                if workoutManager.running {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: true)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                }

                // Use your existing staminaBarView logic here
                (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)

                HStack {
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())

                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}




struct HeartRateViewView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView().environmentObject(WorkoutManager())
    }
}

// Workout builder helper
private struct HeartRateViewTimelineSchedule: TimelineSchedule {
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

