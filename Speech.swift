//
//  Speech.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import AVFoundation

class SpeechSynthesizerManager: ObservableObject {
    @Published var synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.9
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
         synthesizer.stopSpeaking(at: .immediate)
    }
}
