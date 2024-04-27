//
//  GeminiXApp.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI
import SwiftData

@main
struct GeminiXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SpeechSynthesizerManager())
        }.modelContainer(for: [Chat.self, ChatDetails.self])
    }
}
