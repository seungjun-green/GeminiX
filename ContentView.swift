//
//  ContentView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI

struct ContentView: View {    
    @State private var currentMode = "Simulation"
    let modes = ["ChatMode", "PromptEng", "Vision", "Simulation"]
    var body: some View {
        VStack{
            Picker("", selection: $currentMode) {
                ForEach(modes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            
            if currentMode == "ChatMode" {
                ChatView()
            } else if currentMode == "PromptEng" {
                Text("Coming soon!")
            } else if currentMode == "Vision" {
                VStack{
                    Vision()
                }
                
            } else {
                AIVSAI()
            }
            
        }
    }
}
