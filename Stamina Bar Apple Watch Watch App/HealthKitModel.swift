//
//  HealthKitModel.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitModel: ObservableObject {
    var healthStore: HKHealthStore?
    var query: HKQuery?
    @Published var isHeartRateAvailable: Bool = false
    @Published var latestHeartRate: Double = 0.0

    @Published var isHeartRateVariabilityAvailable: Bool = false
    @Published var latestHeartRateVariability: Double = 0
    
    @Published var isV02MaxAvailable: Bool = false
    @Published var latestV02Max: Double = 0.0
    @Published var latestStepCount: Int = 0
    @Published var latestActiveEnergy: Double = 0.0
    @Published var latestRestingEnergy: Double = 0.0


    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
        let readTypes: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        
        healthStore?.requestAuthorization(toShare: [], read: readTypes) { success, error in
            if success {
                self.startHeartRateVariabilityQuery()
                self.startHeartRateQuery()
                self.startV02MaxQuery()
                self.fetchDailyStepCount()
                self.startActiveEnergyQuery()
                self.startRestingEnergyQuery()
            } else {
                print("Authorization failed")
            }
        }
    }
    
    func startActiveEnergyQuery() {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Active Energy type is unavailable.")
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKAnchoredObjectQuery(type: activeEnergyType,
                                          predicate: predicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.processActiveEnergySamples(samples)
        }

        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.processActiveEnergySamples(samples)
        }

        healthStore?.execute(query)
    }
    
    private func processActiveEnergySamples(_ samples: [HKSample]?) {
        guard let energySamples = samples as? [HKQuantitySample] else {
            print("Could not extract active energy samples.")
            return
        }

        let totalEnergy = energySamples.reduce(0.0) { (result, sample) -> Double in
            return result + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
        }

        DispatchQueue.main.async {
            self.latestActiveEnergy = totalEnergy
            print("Updated latest active energy: \(self.latestActiveEnergy) kcal")
        }
    }

        
    
    func startRestingEnergyQuery() {
        guard let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) else {

            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKAnchoredObjectQuery(type: restingEnergyType,
                                          predicate: predicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.processRestingSamples(samples)
        }

        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.processRestingSamples(samples)
        }

        healthStore?.execute(query)
    }
    
    private func processRestingSamples(_ samples: [HKSample]?) {
        guard let energySamples = samples as? [HKQuantitySample] else {

            return
        }

        let totalEnergy2 = energySamples.reduce(0.0) { (result, sample) -> Double in
            return result + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
        }

        DispatchQueue.main.async {
            self.latestRestingEnergy = totalEnergy2
//            print("Updated latest resting energy: \(self.latestRestingEnergy) kcal")
        }
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
                    self.latestStepCount = Int((sum.doubleValue(for: HKUnit.count())))
                }
            }
        }
        healthStore?.execute(query)
    }


    private func updateStepCounts(_ samples: [HKSample]?) {
        guard let stepSamples = samples as? [HKQuantitySample] else {
            print("Could not extract step count samples.")
            return
        }

        DispatchQueue.main.async {
            let totalSteps = stepSamples.reduce(0) { (result, sample) -> Int in
                return result + Int(sample.quantity.doubleValue(for: HKUnit.count()))
            }
            self.latestStepCount = totalSteps  // This is an Int, so no decimals
        }
    }

    func startV02MaxQuery() {
        guard let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max) else { return }

        let query = HKAnchoredObjectQuery(type: vo2MaxType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateVO2Max(samples)
        }

        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateVO2Max(samples)
        }

        healthStore?.execute(query)
        self.query = query
    }
    
    private func updateVO2Max(_ samples: [HKSample]?) {
        guard let vo2MaxSamples = samples as? [HKQuantitySample] else { return }

        DispatchQueue.main.async {
            self.latestV02Max = vo2MaxSamples.last?.quantity.doubleValue(for: HKUnit(from: "ml/kg*min")) ?? 0
        }
    }


    
    func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateHeartRates(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateHeartRates(samples)
        }
        
        healthStore?.execute(query)
        self.query = query
    }
    
    func startHeartRateVariabilityQuery() {
        guard let heartRateVariabilityType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateVariabilityType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateHeartRateVariability(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateHeartRateVariability(samples)
        }
        
        healthStore?.execute(query)
        self.query = query
    }
    
    private func updateHeartRates(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRate = heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            self.isHeartRateAvailable = !heartRateSamples.isEmpty
        }
    }
    
    private func updateHeartRateVariability(_ samples: [HKSample]? ) {
        guard let heartRateVariabilitySample = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRateVariability = heartRateVariabilitySample.last?.quantity.doubleValue(for: HKUnit(from: "ms")) ?? 0
            self.isHeartRateVariabilityAvailable = !heartRateVariabilitySample.isEmpty
        }
    }
}
