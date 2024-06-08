//
//  ChatView.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/22/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ViewModel
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stamina Bar Pro")
                .bold()
                .font(.title)
            Divider()
            Text("Say, \"Hello!\" to start a conversation with your A.I. Personal Trainer.")
            
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
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
        .padding()
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
    }
}

