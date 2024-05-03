//
//  CustomPrompts.swift
//  GeminiX
//
//  Created by SeungJun Lee on 5/1/24.
//

import SwiftUI
import SwiftData

struct CustomPromptsView: View {
    @Query(sort: \CustomPrompts.date, order: .reverse) var customPrompts: [CustomPrompts]
    @Environment(\.modelContext) var context
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var editingMode = false
    @State private var selectedPrompt: CustomPrompts? = nil
    let modelManager = ModelManager()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack{
                VStack{
                    
                    
                    Button {
                        let newPrompt = CustomPrompts(name: "New Prompt")
                        context.insert(newPrompt)
                    } label: {
                        HStack{
                            Text("New Prompt")
                            
                            Spacer()
                            
                            Image(systemName: "square.and.pencil")
                        }.font(.title3)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.bottom)
                    
                    
                    
                    
                    Divider()
                    
                    ScrollViewReader { proxy in
                        
                        List(selection: $selectedPrompt){
                            ForEach(customPrompts) { customPrompt in
                                
                                Button(action: {
                                    selectedPrompt = customPrompt
                                }) {
                                    HStack {
                                        Text(customPrompt.name)
                                        Spacer()
                                    }.frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedPrompt?.id == customPrompt.id ? Color.blue : Color.clear)
                                        .cornerRadius(8)
                                }.id(customPrompt.id)
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    .navigationTitle("Prompts")
                    
                }
                
            }.navigationTitle("Prompts")
        } detail: {
            
            if let selectedPrompt = selectedPrompt {
                PromptDetailsView(modelManager: modelManager, prompt: selectedPrompt)
            } else {
                Text("Please select a prompt")
                    .font(.title)
            }
            
            
            
        }.navigationSplitViewStyle(.balanced)
        
    }
    
}


