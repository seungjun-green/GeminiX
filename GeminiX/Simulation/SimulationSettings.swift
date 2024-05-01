//
//  SimulationSettings.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import SwiftUI

struct AIVSAISetting: View {
    @Binding var user1: String
    @Binding var user2: String
    @Binding var users: [String]
    @Binding var selectedUser: String
    @Binding var firstMessage: String
    
    
    var body: some View {
        VStack{
            
            TitleView(title: "Set Roles").font(.title2).fontWeight(.medium).padding(.top)
            
            
            HStack{
                
                VStack{
                    TitleView(title: "User 1").font(.title3).fontWeight(.medium).padding(.top)
                    TextField("Set roles for User 1", text: $user1).textFieldStyle(.roundedBorder).padding()
                        .onChange(of: user1) { oldValue, newValue in
                            users[0] = newValue
                        }
                }
                
                
                Spacer()
                
                VStack{
                    TitleView(title: "User 2").font(.title3).fontWeight(.medium).padding(.top)
                    TextField("Set roles for User 2", text: $user2).textFieldStyle(.roundedBorder).padding()
                        .onChange(of: user2) { oldValue, newValue in
                            users[1] = newValue
                        }
                }
                
                
            }.padding()
            
            VStack{
                
                TitleView(title: "Start").font(.title3).fontWeight(.medium).padding(.top)
                
                
                Picker("Who's gonna start conv?", selection: $selectedUser) {
                    ForEach(users, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom])
            }
            
            VStack{
                TitleView(title: "First Message of \(selectedUser)").font(.title3).fontWeight(.medium).padding(.top)
                TextField("First message", text: $firstMessage).textFieldStyle(.roundedBorder).padding([.horizontal, .bottom])
            }
            
            
            
            
        }.background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black, radius: 10)

        .padding(.horizontal)
    }
}


