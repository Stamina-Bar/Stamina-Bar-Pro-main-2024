//
//  ChatView.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/22/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView() // Create the WKWebView instance
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request) // Load the URL request
    }
}

struct AlternateIconsView: View {
    @Binding var shouldShowOnboarding: Bool // Pass this state in your parent view
    let icons = ["Default-p", "BLM-p", "USA-p", "Pride-p", "Halloween-p" ]
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 20)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose App Icon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Text("Select your preferred app icon from the options below. Tap on a preview to apply it as your new app icon.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(icons, id: \.self) { icon in
                    Button(action: {
                        setAppIcon(iconName: icon)
                    }) {
                        VStack {
                            Image(icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            
                            Text(icon.dropLast(2))
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Tap to apply")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 120, height: 150)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Buttons for resetting and showing onboarding
            HStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    resetToDefaultIcon()
                }) {
                    Text("Reset to Default Icon")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Button(action: {
                    shouldShowOnboarding = true // Set the onboarding view to reappear
                }) {
                    Text("Re-Onboard")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
            .padding(.bottom)
        }
        .padding(.vertical, 20)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    func setAppIcon(iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        let actualIconName = iconName.replacingOccurrences(of: "-p", with: "")
        let iconNameToSet = actualIconName.isEmpty ? nil : actualIconName
        
        UIApplication.shared.setAlternateIconName(iconNameToSet) { error in
            if let error = error {
                print("Error setting alternate icon: \(error.localizedDescription)")
            } else {
                print("Successfully changed app icon to \(actualIconName)")
            }
        }
    }
    
    func resetToDefaultIcon() {
        UIApplication.shared.setAlternateIconName(nil) { error in
            if let error = error {
                print("Error resetting to default icon: \(error.localizedDescription)")
            } else {
                print("Successfully reset to default app icon")
            }
        }
    }
}


struct ChatView: View {
    @ObservedObject var viewModel: ViewModel
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var isTextVisible: Bool = false // Controls visibility of health questions
    
    var body: some View {
        TabView {
            
            VStack(alignment: .leading) {
                Button(action: {
                    isTextVisible.toggle() // Toggle visibility
                }) {
                    HStack {
                        Text("Ask any Health question.")
                        Spacer()
                        Image(systemName: isTextVisible ? "chevron.up" : "chevron.down")
                    }
                    .padding(.horizontal)
                    .foregroundColor(.blue)
                }
                
                // List of health questions, visible only when `isTextVisible` is true
                if isTextVisible {
                    VStack(alignment: .leading) {
                        
                        
                        ForEach(["What is V02 max and what does my value mean for my overall stamina?", "Is my resting heart rate healthy?", "How does my Heart Rate Variability (HRV) relate to my overall fitness level and stress management?", "Do I need to increase my step count?", "What does my basal energy rate mean for me"], id: \.self) { question in
                            Button(action: {
                                // Send the selected question to the message thread
                                viewModel.currentInput = question
                                viewModel.sendMessage()
                            }) {
                                Text(question)
                                    .padding()
                                    .foregroundColor(.blue)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                
                // ScrollView for the message list
                ScrollView {
                    ForEach(viewModel.messages.filter({ $0.role != .system }), id: \.id) { message in
                        messageView(message: message)
                    }
                }
                
                // Input Field and Send Button
                HStack {
                    TextField("💬 Enter a message...", text: $viewModel.currentInput)
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .foregroundColor(Color.primary)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .padding(.horizontal, 5)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                    
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                            .background(Circle().fill(Color.white))
                    }
                    .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .tabItem {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                Text("AI Chat")
            }
            .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
            })
            .padding()
            
            WebView(url: URL(string: "https://www.staminabar.app/faq")!)
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Info")
                }
            
            AlternateIconsView(shouldShowOnboarding: $shouldShowOnboarding)
                .tabItem {
                    Image(systemName: "square.stack.3d.down.right")
                    Text("App Icons")
                }
            
            if shouldShowOnboarding {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                    .transition(.slide)
            }

                
        }
    }
    
    // Message View Helper
    func messageView(message: Message) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if message.role == .assistant {
                Image("Splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(5)
            } else {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(15)
                .textSelection(.enabled)
            
            if message.role == .user {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .padding(5)
            } else {
                Spacer()
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockWorkoutManager = WorkoutManager()
        let viewModel = ChatView.ViewModel(workoutManager: mockWorkoutManager)
        ChatView(viewModel: viewModel)
            .environmentObject(mockWorkoutManager)
    }
}

