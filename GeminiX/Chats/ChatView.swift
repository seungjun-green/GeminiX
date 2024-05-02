//
//  ChatView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import GoogleGenerativeAI
import SwiftData
import SwiftUI


struct ChatView: View {
    
    @Query(sort: \Chat.date, order: .reverse) var chats: [Chat]
    @Environment(\.modelContext) var context
    @State private var selectedChat: Chat? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var editingMode = false
    @State var ChatID = Date()

    let modelManager = ModelManager()
    
    var body: some View {
        VStack{
            NavigationSplitView(columnVisibility: $columnVisibility) {
                VStack{
                    VStack{
                        
                        
                        Button {
                            let newChat = Chat(date: Date(), name: "New Chat", details: [])
                            context.insert(newChat)
                        } label: {
                            HStack{
                                Text("New Chat")
                                
                                Spacer()
                                
                                Image(systemName: "square.and.pencil")
                            }.font(.title3)
                                .fontWeight(.medium)
                                .padding(.horizontal)
                            
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom)
                        
                        
//                        
//                        Button {
//                            editingMode.toggle()
//                        } label: {
//                            HStack{
//                                Text("Edit")
//                                
//                                Spacer()
//                                
//                                Image(systemName: "slider.horizontal.3")
//                            }.font(.title3)
//                                .fontWeight(.medium)
//                                .padding(.horizontal)
//                            
//                        }.frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        ScrollViewReader { proxy in
                            
                            List(selection: $selectedChat){
                                ForEach(chats) { chat in
                                    
                                    Button(action: {
                                        selectedChat = chat
                                    }) {
                                        HStack {
                                            Text(chat.name).lineLimit(1)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedChat?.id == chat.id ? Color.blue : Color.clear)
                                        .cornerRadius(8)
                                    }.id(chat.date)
                                    
                                    
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        context.delete(chats[index])
                                    }
                                }
                            }
                            .onChange(of: ChatID) { oldValue, newValue in
                                proxy.scrollTo(ChatID)
                            }
                            
                        }
                        .navigationTitle("Chats")
                        
                    }
                    
                }.navigationTitle("Chats")
            } detail: {
                
                VStack{
                    if let selectedChat = selectedChat {
                        DetailView(modelManager: modelManager, chat: selectedChat, ChatID: $ChatID)
                    } else {
                        Text("Please select a chat")
                            .font(.title)
                    }
                }
            }.navigationSplitViewStyle(.balanced)
            
        }
        
    }
    
}



