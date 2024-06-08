//
//  Onboarding.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/4/24.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPage = 0
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TabView(selection: $currentPage) {
                        
                        
            let attributedString = try! AttributedString(markdown:
            """
            Stamina Bar Pro cites information trusted resources that will be included at the end of each response. Resources are cited from but not limited to American Heart Association [AHA](https://www.heart.org/en/healthy-living/fitness/fitness-basics/target-heart-rates), [Mayo Clinic](https://www.mayoclinicproceedings.org), and the American College of Sports Medicine [ACSM](https://www.acsm.org)
            """)
            
            
            PageView(title: "A.I. Personal Trainer", subTitle: attributedString, imageName: "Splash", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
        }
//        .background(Color.gray.gradient)
        .tabViewStyle(.page)
    }
}

struct PageView: View {
    let title: String
    let subTitle: AttributedString
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(spacing: 20) { // Add spacing between elements
            Text(title)
                .font(.system(size: 24, weight: .bold)) // Increase font weight for better emphasis
                .padding(.top, 40) // Add padding at the top for spacing from the header or status bar
            
            Image(imageName)
                .resizable()
                .scaledToFit() // Changed to scaledToFit to maintain the aspect ratio without cropping
                .frame(width: 200, height: 200) // Increased size for better visibility
                .padding() // Add padding to give breathing space around the image
            
            Text(subTitle)
                .font(.system(size: 18))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal) // Add horizontal padding to ensure text doesn't touch the edges
            
            if showsDismissButton { // Conditionally show the dismiss button
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Get Started")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity) // Make button width to expand
                        .padding() // Add padding to increase the button's tap area
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .padding(.horizontal, 50) // Add horizontal padding to button
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make VStack take the full available size
        .onAppear {
            workoutManager.requestAuthorization { authorized, error in }
        }
    }
}

