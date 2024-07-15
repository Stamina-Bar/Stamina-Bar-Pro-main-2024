//
//  WorkoutManager.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    private var healthUpdateTimer: Timer?

    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }

    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }

    init(selectedWorkout: HKWorkoutActivityType? = nil) {
            self.selectedWorkout = selectedWorkout
        }

    var builder: HKLiveWorkoutBuilder?
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?

    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in

        }
        self.fetchDailyActiveEnergyBurned()
        self.fetchDailyBasalEnergyBurn()
        self.fetchMostRecentVO2Max()
        self.fetchMostRecentHRV()
        self.fetchDailyStepCount()
    }

    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in

        }
    }

    // MARK: - Session State Control

    @Published var running = true

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
        showingSummaryView = true
        healthUpdateTimer?.invalidate()
        healthUpdateTimer = nil

    }

    @Published var heartRateVariability: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var basalEnergy: Double = 0
    @Published var totalDailyEnergy: Double = 0
    @Published var currentVO2Max: Double = 0
    @Published var previousVO2Max: Double = 0
    @Published var dailyStepCount: Int = 0
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let mileUnit = HKUnit.mile()
                self.distance = statistics.sumQuantity()?.doubleValue(for: mileUnit) ?? 0

            default:
                return
            }
        }
    }

    func resetWorkout() {
        heartRateVariability = 0
        selectedWorkout = nil
        activeEnergy = 0
        basalEnergy = 0
        totalDailyEnergy = 0
        dailyStepCount = 0
        heartRate = 0
        distance = 0
        builder = nil
        workout = nil
        session = nil
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }

}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {


    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            DispatchQueue.main.async {
                self.updateForStatistics(statistics)
            }
        }
    }

    func fetchMostRecentHRV() {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            return
        }
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: hrvType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] (_, samples, _) in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKQuantitySample], let mostRecentSample = samples.first else {
                    return
                }
                self?.heartRateVariability = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "ms"))
            }
        }
        self.healthStore.execute(query)
    }

    func fetchDailyBasalEnergyBurn() {
        guard let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) else {
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        let query = HKStatisticsQuery(quantityType: restingEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }

            let basalEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self?.basalEnergy = basalEnergy
            }
        }

        healthStore.execute(query)
    }

    func fetchDailyActiveEnergyBurned() {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }

            let activeEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self?.totalDailyEnergy = activeEnergy
            }
        }
        healthStore.execute(query)
    }

    func fetchDailyStepCount() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let startTime = Date()

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            // Calculate elapsed time
            let elapsedTime = Date().timeIntervalSince(startTime)

            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count()).rounded()
                DispatchQueue.main.async {
                    self.dailyStepCount = Int((sum.doubleValue(for: HKUnit.count())))
                }
            }
        }
        healthStore.execute(query)
    }

    func fetchMostRecentVO2Max() {
        guard let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max) else {
            return
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let vo2MaxSample = results?.first as? HKQuantitySample else {
                return
            }

            DispatchQueue.main.async {
                self.previousVO2Max = self.currentVO2Max
                self.currentVO2Max = vo2MaxSample.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
            }
        }

        healthStore.execute(query)
    }
}
