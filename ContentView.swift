//
//  ContentView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI

struct ContentView: View {    
    // @ObservedObject var cameraManager = CameraHandler()
    @State private var currentMode = "ChatMode"
    let modes = ["ChatMode", "PromptEng", "Vision", "Simulation"]
    
    var body: some View {
        VStack{
            
            Picker("", selection: $currentMode) {
                ForEach(modes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
         
            
            
            switch(currentMode) {
            case "ChatMode": ChatView()
            case "PromptEng": CustomPromptsView()
            case "Vision": Vision()
            default: AIVSAI()
            }
        }
    }
}


class SharedViewModel: ObservableObject {
    @Published var isCameraLoading: Bool  = false
}
