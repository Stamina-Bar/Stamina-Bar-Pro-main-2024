//
//  ContentView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import SwiftUI
import HealthKit

//struct ContentView: View {
//    @ObservedObject var healthKitModel = HealthKitModel()
//    let staminaBarView = StaminaBarView()
//    @State private var selectedTab: Int = 0
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
////            MARK:
//            VStack {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//            }
//            .tag(0)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "heart.fill")
//                        .foregroundColor(.red)
//                }
//            }
//            .tag(1)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "waveform.path.ecg")
//                        .foregroundColor(.blue)
//                }
//            }
//            .tag(2)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(String(format: "%.1f", healthKitModel.latestV02Max)) VO2 max")
//                        .font(.system(.body, design:
//                                .rounded).monospacedDigit().lowercaseSmallCaps())
//                    
//                    Image(systemName: "lungs.fill")
//                        .foregroundColor(.green)
//                    
//                }
//            }
//            .tag(3)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(healthKitModel.latestStepCount) Steps")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "shoeprints.fill")
//                        .foregroundColor(.blue)
//                }
//            }
//            .tag(4)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(String(format: "%.0f", healthKitModel.latestRestingEnergy)) Cals")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "flame.fill")
//                        .foregroundColor(.orange)
//                }
//            }
//            .tag(5)
////            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//        }
//        .onTapGesture(count: 2) {
//            healthKitModel.fetchDailyStepCount()
//            healthKitModel.startRestingEnergyQuery()
//            healthKitModel.startHeartRateQuery()
//        }
//        .tabViewStyle(.verticalPage)
//    }
//    
//    func colorForHeartRateAndHRV(heartRate: CGFloat, hrv: CGFloat) -> Color {
//        // Calculate the stamina percentage based on HR and HRV
//        let finalStaminaPercentage = calculateStamina(heartRate: heartRate, hrv: hrv)
//        
//        // Determine the color based on the calculated stamina percentage
//        return colorForStamina(staminaPercentage: finalStaminaPercentage)
//    }
//    
//    private func bryceStaminaContainerBackground(heartRate: CGFloat, heartRateVariability: CGFloat) {
//        
//        var heartRateVariability = healthKitModel.latestHeartRateVariability
//        var heartRate = healthKitModel.latestHeartRate
//        
//        
//        /// AVERAGE the HEART RATE AND HRV
//        /// Set the container background color 
//
//    }
//    
//    private func calculateStamina(heartRate: CGFloat, hrv: CGFloat) -> CGFloat {
//        let baselineHRV: CGFloat = 65
//        let adjustmentFactor: CGFloat = 0.5
//        let hrvAdjustment = (baselineHRV - hrv) * adjustmentFactor
//        
//        // Example calculation, adjust according to your specific formula
//        let initialStamina: CGFloat = 100 - (heartRate - 60) / 2  // Simplified example
//        return max(initialStamina - hrvAdjustment, 0)  // Ensure stamina does not go below 0
//    }
//    
//    private func colorForStamina(staminaPercentage: CGFloat) -> Color {
//        switch staminaPercentage {
//        case 91...:
//            return .blue
//        case 79..<90:
//            return .green
//        case 50..<79:
//            return .yellow
//        case 30..<50:
//            return .orange
//        default:
//            return .red
//        }
//    }
//}
