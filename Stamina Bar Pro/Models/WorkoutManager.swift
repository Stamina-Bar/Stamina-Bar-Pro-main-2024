//
//  WorkoutManager.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/4/24.
//

import SwiftUI
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    let healthStore = HKHealthStore()

    // Check if HealthKit is available on this device
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    // Request Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let readTypes: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            completion(success, error)
        }
    } // TODO: DEBUG

    // Modified fetchDailySteps with completion handler
        func fetchDailySteps(completion: @escaping (Double?, Error?) -> Void) {
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let sum = result?.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count()).rounded()
                    completion(steps, nil)
                } else {
                    completion(nil, nil) // No data available
                }
            }

            healthStore.execute(query)
        }

        // Modified fetchDailyBasalEnergyBurned with completion handler
        func fetchDailyBasalEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
            let energyType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!

            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let sum = result?.sumQuantity() {
                    let energyBurned = sum.doubleValue(for: HKUnit.kilocalorie()).rounded()
                    completion(energyBurned, nil)
                } else {
                    completion(nil, nil) // No data available
                }
            }

            healthStore.execute(query)
        }

    // Fetch Heart Rate
        func fetchHeartRate(completion: @escaping (Double?, Error?) -> Void) {
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

            // Fetch the most recent sample.
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let sample = samples?.first as? HKQuantitySample {
                    let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min")).rounded()
                    completion(heartRate, nil)
                } else {
                    completion(nil, nil)
                }
            }

            healthStore.execute(query)
        }

        // Fetch Heart Rate Variability
        func fetchHeartRateVariability(completion: @escaping (Double?, Error?) -> Void) {
            let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!

            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: hrvType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let sample = samples?.first as? HKQuantitySample {
                    let hrv = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli)).rounded()
                    completion(hrv, nil)
                } else {
                    completion(nil, nil)
                }
            }

            healthStore.execute(query)
        }

        // Fetch VO2 Max
        func fetchVO2Max(completion: @escaping (Double?, Error?) -> Void) {
            let vo2MaxType = HKQuantityType.quantityType(forIdentifier: .vo2Max)!

            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let sample = samples?.first as? HKQuantitySample {
                    let vo2Max = sample.quantity.doubleValue(for: HKUnit(from: "ml/kg*min")).rounded()
                    completion(vo2Max, nil)
                } else {
                    completion(nil, nil)
                }
            }

            healthStore.execute(query)
        }
    
}

