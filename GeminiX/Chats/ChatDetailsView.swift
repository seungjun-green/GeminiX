//
//  ChatDetailsView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI
import PDFKit
import SwiftData

struct DetailView: View {
    @State private var importing = false
    
    var userInfo = UserDefaults.standard.string(forKey: "userInfo") ?? "No value"
    let saveUserInfoPrompt = """
## Example 1
Input: Remember that favorite sport is soccer.
Output: favorite sport: soccer
    
    ## Example 2
Input: Remember that my name is Seungjun Lee
Output: name: Seungjun Lee
    
    ## Example 3
Input:
"""
    let defaultInfo = "species: human"
    
    var modelManager: ModelManager
    @Environment(\.modelContext) var context
    @State private var messageText = ""
    @Bindable var chat: Chat
    
    @Binding var ChatID: Date
    
    
    @State private var MintextEditorHeight: CGFloat = 50
    @State private var MaxtextEditorHeight: CGFloat = 300
    
    @State private var generating = false
    @State private var AIResponse = ""
    @State private var contextProvided = false
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State private var currGeneratingMessageID = UUID()
    
    var sortedDetails: [ChatDetails] {
        chat.details.sorted(by: { $0.date < $1.date })
    }
    
    
    var promptIsEmpty: Bool {
        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    @State private var providedContext = ""
    
    func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(sortedDetails.last?.uuid, anchor: .bottom)
        }
    }
    
    func scrollToBottom2() {
        withAnimation {
            scrollProxy?.scrollTo(currGeneratingMessageID, anchor: .bottom)
        }
    }
    
    var body: some View {
        VStack{
            
            
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(sortedDetails) { currMessage in
                        MessageBubble(isHuman: currMessage.isHuman, text: currMessage.message)
                            .id(currMessage.uuid)
                            .listRowSeparator(.hidden, edges: [.bottom])
                    } .onAppear {
                        scrollProxy = proxy
                    }
                    
                    VStack{
                        if generating {
                            MessageBubble(isHuman: false, text: AIResponse)
                                .listRowSeparator(.hidden, edges: [.bottom])
                        }
                    }.id(currGeneratingMessageID)
                   
                }
            }.onChange(of: sortedDetails) { oldValue, newValue in
                print("This part was triggered")
                scrollToBottom()
            }.onChange(of: AIResponse) { oldValue, newValue in
                scrollToBottom2()
            }
            
            
            VStack{
                
                
                HStack(alignment: .bottom){
                    
                    Button {
                        importing = true
                    } label: {
                        if contextProvided {
                            Image(systemName: "filemenu.and.selection").font(.title3).imageScale(.large)
                            
                        } else {
                            Image(systemName: "filemenu.and.cursorarrow").font(.title3).imageScale(.large)
                        }
                        
                    }
                    .fileImporter(
                        isPresented: $importing,
                        allowedContentTypes: [.pdf]
                    ) { result in
                        switch result {
                        case .success(let file):
                            print(file.absoluteString)
                            
                            if let pdf = PDFDocument(url: URL(string: file.absoluteString)!) {
                                let pageCount = pdf.pageCount
                                let documentContent = NSMutableAttributedString()
                                
                                for i in 0 ..< pageCount {
                                    guard let page = pdf.page(at: i) else { continue }
                                    guard let pageContent = page.attributedString else { continue }
                                    documentContent.append(pageContent)
                                }
                                
                                providedContext = documentContent.string
                                contextProvided = true
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            contextProvided = false
                        }
                    }
                    
                    
                    TextField("Message Gemmini", text: $messageText, axis: .vertical)
                        .padding(.horizontal)
                        .onSubmit {
                            performActions()
                        }
                        .font(.title3)
                    
                    
                    
                    if generating {
                        Button {
                            // do nothing
                        } label: {
                            Image(systemName: "stop.circle.fill").font(.title3).imageScale(.large)
                        }

                    } else {
                        Button {
                            performActions()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill").font(.title3).imageScale(.large)
                        }.keyboardShortcut(.defaultAction)
                        .disabled(promptIsEmpty)
                    }
                    
                    
                   
                   
                    
                    
                    
                }
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 1)
                )
                .padding()
                
            }
        }
    }
    
    func constuctHistory() -> [ModelContent] {
        var history = [ModelContent]()
        
        
        history.append(ModelContent(role: "user", parts: "HI, Here are some information about me. \(UserDefaults.standard.string(forKey: "userInfo") ?? "No value")"))
        history.append(ModelContent(role: "model", parts: "Okay, I got it."))
        
        for example in chat.details.sorted(by: { $0.date < $1.date}) {
            if example.isHuman {
                history.append(ModelContent(role: "user", parts: example.message))
            } else {
                history.append(ModelContent(role: "model", parts: example.message))
            }
        }
        return history
    }
    
    
    
    func performActions() {
        // update the title if it's firt time having chat
        if chat.details.count == 0 {
            print("Update the title")
            chat.name = messageText
        }
        
        chat.date = Date()
        ChatID = chat.date
        
        
        generating = true
        
        
        // generate AI's response
        let history = constuctHistory()
        chat.details.append(ChatDetails(message: messageText, isHuman: true))
        
        
        // save user's info
        if messageText.starts(with: "Remember that") {
            
            var newUserInfo = ""
            
            
            var prompt = messageText
            
            
            print("Updating information about user")
            var userInfo = UserDefaults.standard.string(forKey: "userInfo") ?? "No value"
            
            
            prompt = saveUserInfoPrompt + prompt
            modelManager.generateString(from: saveUserInfoPrompt + messageText + "\nOutput:") { result in
                switch result {
                case .success(let text):
                    print(text)
                    newUserInfo = text
                    userInfo += "\n\(newUserInfo)"
                    UserDefaults.standard.set(userInfo, forKey: "userInfo")
                    print(UserDefaults.standard.string(forKey: "userInfo") ?? "No value")
                case .failure(let error):
                    print("Error generating content: \(error.localizedDescription)")
                }
            }
        }
        
        
        // get AI's response
        var AI_response = ""
        let prompt = messageText + providedContext
        messageText = ""
        
        
        modelManager.chatModeStream(prompt: prompt, history: history, onChunkReceived: { chunk in
            print(chunk)
            AI_response += chunk
            DispatchQueue.main.async {
                AIResponse = AI_response
            }
        }, completion: { error in
            DispatchQueue.main.async {
                if let error = error {
                    AIResponse = "ERROR HAPPEND"
                    AI_response = "ERROR HAPPEND"
                    print("Error generating content: \(error.localizedDescription)")
                } else {
                    print("Streaming complete.")
                }
                
                generating = false
                
                // add messges to chat history
                
                chat.details.append(ChatDetails(message: AI_response, isHuman: false))
                
                // save it to SwiftData
                do {
                    try context.save()
                } catch {
                    print("ddd")
                }
                
                messageText = ""
                AI_response = ""
                AIResponse = ""
                
                providedContext = ""
                contextProvided = false
            }
            
        })
    }
}

