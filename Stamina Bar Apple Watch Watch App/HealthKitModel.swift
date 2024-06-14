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

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
//        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
//            return
//        }
        let readTypes: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!]

        
        healthStore?.requestAuthorization(toShare: [], read: readTypes) { success, error in
            if success {
                self.startHeartRateQuery()
                self.startHeartRateVariabilityQuery()
            } else {
                print("Authorization failed")
            }
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
            // print("Latest Heart Rate: \(self.latestHeartRate)")
        }
    }
    
    private func updateHeartRateVariability(_ samples: [HKSample]? ) {
        guard let heartRateVariabilitySample = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRateVariability = heartRateVariabilitySample.last?.quantity.doubleValue(for: HKUnit(from: "ms")) ?? 0
            self.isHeartRateVariabilityAvailable = !heartRateVariabilitySample.isEmpty
            print("Latest HRV: \(self.latestHeartRateVariability)")
        }
        
        
    }
}
