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
    // Array of icons with the "-p" prefix to indicate preview images
    let icons = ["Default-p", "BLM-p", "USA-p", "Pride-p", "Halloween-p" ]
    
    // Adaptive grid layout for a more organized presentation
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 20)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Heading
            Text("Choose App Icon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Description
            Text("Select your preferred app icon from the options below. Tap on a preview to apply it as your new app icon.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Grid layout for Icons
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(icons, id: \.self) { icon in
                    Button(action: {
                        setAppIcon(iconName: icon)
                    }) {
                        VStack {
                            // Icon Image
                            Image(icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            
                            // Icon Name without "-p"
                            Text(icon.dropLast(2))
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            // Description of the action
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
            
            // Additional Element: Reset Button
            HStack {
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
                Spacer()
            }
            .padding(.bottom)
        }
        .padding(.vertical, 20)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    func setAppIcon(iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        // Remove "-p" from the icon name to get the actual icon name
        let actualIconName = iconName.replacingOccurrences(of: "-p", with: "")
        let iconNameToSet = actualIconName.isEmpty ? nil : actualIconName // Handle case where iconName is empty
        
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
    
    var body: some View {
        
        
        TabView {
//            HealthDataMetricsView()
//                .tabItem {
//                    Image(systemName: "bubble.left.and.text.bubble.right.fill")
//                    Text("AI Chat")
//                }
            
            
            VStack(alignment: .leading) {
                Text("Stamina Bar Pro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Divider()
                Text("Ask any Health question.")
                
                ScrollView {
                    ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                        messageView(message: message)
                    }
                }
                
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
            
            AlternateIconsView()
                .tabItem {
                    Image(systemName: "square.stack.3d.down.right")
                    Text("App Icons")
                }
            
            WebView(url: URL(string: "https://www.staminabar.app/faq")!)
                .edgesIgnoringSafeArea(.all) 
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Info")
                }
            
            
        }
        
        
    }
    
    
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
            //                .background(message.role.messageBackgroundColor)
                .foregroundColor(message.role == .user ? .white : .primary) // Adjusted for better text visibility
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

