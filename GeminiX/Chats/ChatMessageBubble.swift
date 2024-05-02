//
//  ChatMessageBubble.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation


struct MessageBubble: View {
    var isHuman: Bool
    var text: String
    @State private var textCopied = false
    @State private var isSpeaking = false
    @EnvironmentObject var speechManager: SpeechSynthesizerManager
    
    var body: some View {
        VStack{
            
            HStack{
                
                VStack{
                    if isHuman {
                        Label("You", systemImage: "person.circle.fill").foregroundColor(.blue)
                    } else {
                        Label("Gemini", systemImage: "cpu.fill").foregroundColor(.blue)
                    }
                }.font(.title3).fontWeight(.medium)
                
                
                Spacer()
            }.padding()
            
            VStack{
                HStack {
                    Text(text)
                        .font(.title3)
                        .padding(.leading)
                    Spacer()
                }
                
                if !isHuman {
                    HStack{
                        
                        
                        Button {
                            if isSpeaking {
                                speechManager.stopSpeaking()
                                isSpeaking = false
                            } else {
                                isSpeaking = true
                                speechManager.speak(text: text)
                                isSpeaking = false
                            }
                        } label: {
                            
                            if isSpeaking {
                                Image(systemName: "stop.circle.fill")
                                    .frame(width: 20)
                                    .foregroundColor(.secondary)
                            } else {
                                Image(systemName: "speaker.wave.3.fill")
                                    .frame(width: 20)
                                    .foregroundColor(.secondary)
                            }
                            
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                        
                        Button {
                            UIPasteboard.general.string =  text
                            textCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                textCopied = false
                            }
                            
                            
                            
                        } label: {
                            if textCopied {
                                Image(systemName: "checkmark").foregroundColor(.secondary)
                                
                            } else {
                                Image(systemName: "doc.on.doc.fill").foregroundColor(.secondary)
                            }
                        }.buttonStyle(PlainButtonStyle())

                        Spacer()
                    }.frame(height: 20)
                    .padding([.horizontal, .top])
                    
                }
            }
        }
    }
}
