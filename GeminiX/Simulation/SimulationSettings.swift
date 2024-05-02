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
    @Binding var hide: Bool
    
    
    var body: some View {
        VStack{
                        
            
            HStack{
                Text("Simulation Setting").font(.title2).fontWeight(.medium)
                
                Spacer()
                
                Button {
                    hide.toggle()
                } label: {
                    if hide {
                        Label("Open", systemImage: "roman.shade.open")
                    } else {
                        Label("Hide", systemImage: "roller.shade.open")
                    }
                }

                
            }.padding()
            
            
            if !hide {
                HStack{
                    
                    VStack{
                        HStack{
                            Text("User 1").font(.title3).fontWeight(.medium)
                            Spacer()
                        }
                        TextField("Set roles for User 1", text: $user1).textFieldStyle(.roundedBorder)
                            .onChange(of: user1) { oldValue, newValue in
                                users[0] = newValue
                            }
                    }
                    
                    
                    Spacer()
                    
                    VStack{
                        
                        HStack{
                            Text("User 2").font(.title3).fontWeight(.medium)
                            Spacer()
                        }
                        TextField("Set roles for User 2", text: $user2).textFieldStyle(.roundedBorder)
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
            }
           
            
            
            
            
        }.background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black, radius: 10)

        .padding(.horizontal)
    }
}


