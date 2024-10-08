//
//  ChatViewModel.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/22/24.
//

import Foundation

extension ChatView {
    
    class ViewModel: ObservableObject {
        private let workoutManager: WorkoutManager
        
        init(workoutManager: WorkoutManager) {
            self.workoutManager = workoutManager
        }
        
        @Published var messages: [Message] = [Message(id: "first-message", role: .system, content: "Act as an intelligent Personal Trainer with expertise in building stamina. Your personality is conversational, empathetic, and mentor-like. When users inquire about their health or exercise plans, leverage their health data to engage in a conversation that is both actionable and informative. You are also capable of providing functional workouts, mobility exercises, and recovery management tips. Asking clarifying questions to better understand the user’s condition or goals is encouraged. Structure your responses as follows: Start with a TL;DR: A concise summary that gives the user the most important information in one or two sentences. Provide clear, practical advice based on the user's question or health data using 1-2 paragraphs, and more only if that ask. Cite reliable sources: At the end of your response, cite a trusted source relevant to the user’s query.", createAt: Date())]
        
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            // First, process the user's input as a separate message
            processUserMessage()
            
            // Then, fetch and process health data
            fetchHealthKitData { [weak self] healthDataPrompt in
                guard let self = self else { return }
                self.processHealthDataMessage(healthDataPrompt)
            }
        }
        
        private func processUserMessage() {
            let userMessage = Message(id: UUID().uuidString, role: .user, content: currentInput, createAt: Date())
            self.messages.append(userMessage)
            self.currentInput = ""
        }
        
        private func processHealthDataMessage(_ healthData: String) {
            // Create a new system message for health data
            let healthDataMessage = Message(id: UUID().uuidString, role: .system, content: healthData, createAt: Date())
            self.messages.append(healthDataMessage)
            
            // Continue with sending this data to OpenAI service or any other processing if needed
            self.openAIService.sendStreamMessage(messages: self.messages).responseStreamString { [weak self] stream in
                guard let self = self else { return }
                switch stream.event {
                case .stream(let response):
                    switch response {
                    case .success(let string):
                        let streamResponse = self.parseStreamData(string)
                        self.handleStreamResponse(streamResponse)
                    case .failure(_):
                        // TODO: Some visual UI to explain error
                        print("Something failed")
                    }
                case .complete(_):
                    // TODO: Haptic Feedback that response is done
                    print(Date())
                }
            }
        }
        
        private func fetchHealthKitData(completion: @escaping (String) -> Void) {
            var healthDataPrompts = [String]()
            let group = DispatchGroup()
            
            // 1
            group.enter()
            workoutManager.fetchVO2Max { v02Max, error in
                if let v02Max = v02Max {
                    healthDataPrompts.append("Health Data: \(Int(v02Max)) V02 max")
                }
                group.leave()
            }
            
            // 2
            group.enter()
            workoutManager.fetchHeartRateVariability { heartRateVariability, error in
                if let heartRateVariability = heartRateVariability {
                    healthDataPrompts.append("Health Data: \(Int(heartRateVariability)) Heart Rate variability")
                }
                group.leave()
            }
            
            // 3
            group.enter()
            workoutManager.fetchHeartRate { heartRate, error in
                if let heartRate = heartRate {
                    healthDataPrompts.append("Health Data: \(Int(heartRate)) heart rate.")
                }
                group.leave()
            }
            
            // 4
            group.enter()
            workoutManager.fetchDailySteps { steps, error in
                if let steps = steps {
                    healthDataPrompts.append("Health Data: \(Int(steps)) steps taken today.")
                }
                group.leave()
            }
            
            // 5
            group.enter()
            workoutManager.fetchDailyBasalEnergyBurned { basalEnergy, error in
                if let basalEnergy = basalEnergy {
                    healthDataPrompts.append("Health Data: \(Int(basalEnergy)) basal energy.")
                }
                group.leave()
            }
            
          
            
            group.notify(queue: .main) {
                let aggregatedHealthData = healthDataPrompts.joined(separator: "\n")
                completion(aggregatedHealthData)
            }
        }
        
        
        private func handleStreamResponse(_ responses: [ChatStreamCompletionResponse]) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for newMessageResponse in responses {
                    guard let messageContent = newMessageResponse.choices.first?.delta.content else {
                        continue
                    }
                    if let existingMessageIndex = self.messages.lastIndex(where: {$0.id == newMessageResponse.id}) {
                        // Append new content to the existing message
                        let existingMessage = self.messages[existingMessageIndex]
                        let updatedMessage = Message(id: existingMessage.id, role: existingMessage.role, content: existingMessage.content + messageContent, createAt: existingMessage.createAt)
                        self.messages[existingMessageIndex] = updatedMessage
                    } else {
                        // Create new message if not existing
                        let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: messageContent, createAt: Date())
                        self.messages.append(newMessage)
                    }
                }
            }
        }
        
        func parseStreamData(_ data: String) ->[ChatStreamCompletionResponse] {
            let responseStrings = data.split(separator: "data:").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({!$0.isEmpty})
            let jsonDecoder = JSONDecoder()
            
            return responseStrings.compactMap { jsonString in
                guard let jsonData = jsonString.data(using: .utf8), let streamResponse = try? jsonDecoder.decode(ChatStreamCompletionResponse.self, from: jsonData) else {
                    return nil
                }
                return streamResponse
            }
        }
    }
}


/// Supporting Views
struct Message: Decodable, Hashable {
    let id: String
    let role: SenderRole
    let content: String
    let createAt: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ChatStreamCompletionResponse: Decodable {
    let id: String
    let choices: [ChatStreamChoice]
}

struct ChatStreamChoice: Decodable {
    let delta: ChatStreamContent
}

struct ChatStreamContent: Decodable {
    let content: String
}
