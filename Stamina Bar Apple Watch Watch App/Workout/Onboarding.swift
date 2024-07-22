//
//  Onboarding.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 7/15/24.
//

import Foundation
import SwiftUI

struct OnboardingView2: View {
    @Binding var shouldShowOnboarding: Bool
    var body: some View {
        TabView {
            
            PageView(pageNumber: 0, title: "Welcome", title2: "Scroll Up", imageSystemName: "digitalcrown.arrow.clockwise.fill", finalOnboardingPage: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "Authorized", title2: "Onboarding Completed ", imageSystemName: "checkmark.circle", finalOnboardingPage: true, shouldShowOnboarding: $shouldShowOnboarding)
            
        }
        .tabViewStyle(.carousel)
    }
}

struct PageView: View {
    let pageNumber: Int
    let title: String
    let title2: String
    
    let imageSystemName: String
    let finalOnboardingPage: Bool
    @Binding var shouldShowOnboarding: Bool
    //    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var healthKitModel = watchOSWorkoutManager()
    
    var body: some View {
        VStack {
            if !finalOnboardingPage {
                Text(title)
                    .font(.title)
                Spacer()
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                
                Text(title2)
                    .font(.subheadline)
            }
            
            else {
                //                Image(systemName: imageSystemName)
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(width: 72, height: 72)
                //
                //                Text(title2)
                //                    .font(.subheadline)
                if #available(watchOS 9.0, *) {
                    
                    
                    Button(action: {
                        shouldShowOnboarding.toggle()
                    }) {
                        Text("Get Started!")
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                    .background(.blue.gradient)
                    .cornerRadius(25)
//                    Image(systemName: imageSystemName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 60, height: 60)
                } else {
                    
                    
                    Button(action: {
                        shouldShowOnboarding.toggle()
                    }) {
                        Text("Get Started!")
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                    .background(.blue.gradient)
                    .cornerRadius(25)

                    
                }
            }
        }
        
        .onAppear {
            if pageNumber == 1 { // Request authorization on the second page
                //                workoutManager.requestAuthorization()
                healthKitModel.requestAuthorization()
            }
        }
    }
}
