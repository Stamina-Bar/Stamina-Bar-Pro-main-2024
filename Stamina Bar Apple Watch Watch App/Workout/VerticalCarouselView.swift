//
//  VerticalCarouselView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.


import Foundation
import SwiftUI

struct VerticalCarouselView: View {
    @State private var carouselSelection = 0
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
            TabView(selection: $carouselSelection) {
                InfoView()
                    .tag(0)
                HeartRateView()
                    .tag(1)
                TotalDistanceView()
                    .tag(2)
                CurrentCaloriesView()
                    .tag(3)
                CardioFitnessView()
                    .tag(4)
            }
            .tabViewStyle(.carousel)
            .navigationBarBackButtonHidden(true)
    }
}
