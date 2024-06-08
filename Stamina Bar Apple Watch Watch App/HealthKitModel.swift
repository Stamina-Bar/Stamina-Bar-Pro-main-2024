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

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
        }
    }
    
    func requestAuthorization() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let typesToRead: Set<HKObjectType> = [heartRateType]
        
        healthStore?.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                self.startHeartRateQuery()
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
    
    private func updateHeartRates(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRate = heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            self.isHeartRateAvailable = !heartRateSamples.isEmpty
            // print("Latest Heart Rate: \(self.latestHeartRate)")
        }
    }
}
