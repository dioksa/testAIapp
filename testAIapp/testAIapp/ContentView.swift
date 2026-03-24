//
//  ContentView.swift
//  testAIapp
//
//  Created by Oksana Dionisieva on 19.03.2026.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    private var languageModel = SystemLanguageModel.default
    private var session = LanguageModelSession()
    
    @State private var response = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Spacer()

            switch languageModel.availability {
            case .available:
                if response.isEmpty {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Tap the button to start new gialog")
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                            .font(.title)
                    }
                } else {
                    Text(response)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .font(.title)
                }
            case .unavailable(.deviceNotEligible):
                Text("Your device isn't eligible for Apple Intelligence")
            case .unavailable(.appleIntelligenceNotEnabled):
                Text("Please enable Apple Intelligence in Settings")
            case .unavailable(.modelNotReady):
                Text("The AI model is not ready")
            case .unavailable(_):
                Text("The AI feature is not available")
            }
            Spacer()

            Button {
                Task {
                    isLoading = true
                    defer { isLoading = false }
                    
                    let prompt = "Hello, how are you today?"
                    do {
                        let reply = try await session.respond(to: prompt)
                        response = reply.content
                    } catch {
                        response = "Failed to get response: \(error)"
                    }
                }
            } label: {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonSizing(.flexible)
            .glassEffect(.regular.interactive())
        }
        .padding()
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
