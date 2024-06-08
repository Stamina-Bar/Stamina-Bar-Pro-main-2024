//
//  ContentView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @ObservedObject var healthKitModel = HealthKitModel()
    let staminaBarView = StaminaBarView()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            VStack {
                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate)
            }
            .tag(0)
            .containerBackground(colorForHeartRate(healthKitModel.latestHeartRate).gradient, for: .tabView)
            
            VStack(alignment: .trailing) {
                staminaBarView.stressFunction(heart_rate: healthKitModel.latestHeartRate)
                HStack {
                    Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            .tag(1)
            .containerBackground(colorForHeartRate(healthKitModel.latestHeartRate).gradient, for: .tabView)
        }
        .tabViewStyle(.verticalPage)
    }

    func colorForHeartRate(_ heartRate: Double) -> Color {
        switch heartRate {
        case ..<96:
            return .blue
        case 96..<120:
            return .green
        case 120..<150:
            return .yellow
        case 150..<180:
            return .orange
        default:
            return .red
        }
    }
}
