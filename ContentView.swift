//
//  ContentView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentMode = "ChatMode"
    let modes = ["ChatMode", "PromptEng", "Vision", "Simulation"]
    
    var body: some View {
        TabView(selection: $currentMode) {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag("ChatMode")
            
            CustomPromptsView()
                .tabItem {
                    Label("Prompts", systemImage: "pencil")
                }
                .tag("PromptEng")
            
            
#if targetEnvironment(macCatalyst)
            Text("Currently, this feature is not available on macOS, please use GeminiX on iPhone or iPad.").font(.title)
                .tabItem {
                    Label("Vision", systemImage: "eye.slash")
                }
                .tag("Vision")
#elseif os(iOS)
            Vision()
                .tabItem {
                    Label("Vision", systemImage: "eye")
                }
                .tag("Vision")
#endif
            
            AIVSAI()
                .tabItem {
                    Label("AI vs AI", systemImage: "cpu")
                }
                .tag("Simulation")
        }
    }
}
