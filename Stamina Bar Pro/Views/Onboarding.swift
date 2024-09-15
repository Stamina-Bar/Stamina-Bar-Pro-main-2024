//
//  Onboarding.swift
//  Stamina Bar Pro
//  iPhone
//  Created by Bryce Ellis on 1/4/24.
//

import Foundation
import SwiftUI

struct PageView: View {
    let title: String
    let subTitle: AttributedString
    let symbolName: String // Use SF Symbols
    let showsDismissButton: Bool
    @Binding var currentPage: Int
    let totalPages: Int
    @Binding var shouldShowOnboarding: Bool
    let requiresAuthorization: Bool
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var animateSymbol = false // State variable for animation
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            // SF Symbol with animation
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue) // Customize the symbol color
                .scaleEffect(animateSymbol ? 1.2 : 1.0) // Expand effect
                .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0.5), value: animateSymbol)
                .onAppear {
                    // Delay the animation by 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        animateSymbol = true // Trigger animation after the delay
                    }
                }
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 40)
            
            Text(subTitle)
                .font(.system(size: 18))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if showsDismissButton {
                Button(action: {
                    shouldShowOnboarding = false
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }) {
                    Text("Get Started")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .padding(.horizontal, 50)
                }
            } else {
                Button(action: {
                    if requiresAuthorization {
                        workoutManager.requestAuthorization { authorized, error in
                            if authorized {
                                print("Authorization successful")
                            } else if let error = error {
                                print("Authorization failed: \(error.localizedDescription)")
                            }
                        }
                    }
                    currentPage += 1
                }) {
                    Text("Next")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .padding(.horizontal, 50)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPage = 0
    @EnvironmentObject var workoutManager: WorkoutManager
    
    let totalPages = 3 // Number of pages in the onboarding
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                
                // First Page
                PageView(
                    title: "A.I. Personal Trainer",
                    subTitle: try! AttributedString(markdown: """
                    Ask personalized health questions and receive advice backed by trusted sources like the [American Heart Association](https://www.heart.org), [Mayo Clinic](https://www.mayoclinic.org), and the [American College of Sports Medicine](https://www.acsm.org).
                    """),
                    symbolName: "brain.filled.head.profile", // Use SF Symbol
                    showsDismissButton: false,
                    currentPage: $currentPage,
                    totalPages: totalPages,
                    shouldShowOnboarding: $shouldShowOnboarding,
                    requiresAuthorization: false)
                .tag(0)
                
                // Second Page - "Health Insights" (trigger authorization here)
                PageView(title: "Health Insights",
                         subTitle: try! AttributedString(markdown: "By connecting with the Apple Health app, you'll gain personalized insights into your fitness and wellness based on data from your Apple Watch or iPhone."),
                         symbolName: "list.clipboard.fill", // Use SF Symbol
                         showsDismissButton: false,
                         currentPage: $currentPage,
                         totalPages: totalPages,
                         shouldShowOnboarding: $shouldShowOnboarding,
                         requiresAuthorization: true) // This triggers authorization
                .tag(1)
                
                // Third and Final Page
                PageView(
                    title: "Track Your Stamina",
                    subTitle: try! AttributedString(markdown: """
                    With the Apple Watch version, monitor your stamina in real-time, receiving a 100-1% score that helps you adjust your intensity based on real-time feedback.
                    """),                         symbolName: "applewatch", // Use SF Symbol
                    showsDismissButton: true,
                    currentPage: $currentPage,
                    totalPages: totalPages,
                    shouldShowOnboarding: $shouldShowOnboarding,
                    requiresAuthorization: false)
                .tag(2)
            }
            .tabViewStyle(.page)
        }
    }
}
