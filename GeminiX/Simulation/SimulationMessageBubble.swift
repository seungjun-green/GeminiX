//
//  SimulationMessageBubble.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import SwiftUI

struct MessageView: View {
    var name: String
    var messageText: String
    var order: Int
    
    var body: some View {
                  

            VStack {
                
                if order == 0 {
                    HStack {
                        Spacer()
                        Text(name).fontWeight(.medium)
                    }
                } else {
                    HStack {
                        Text(name).fontWeight(.medium)
                        Spacer()
                    }
                }
                
                if order == 0 {
                    HStack {
                        Spacer()
                        Text(messageText)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        
                    }
                } else {
                    HStack {
                        Text(messageText)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.secondary)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                
             
               
            }.padding(.horizontal)
        
        
    }
}

