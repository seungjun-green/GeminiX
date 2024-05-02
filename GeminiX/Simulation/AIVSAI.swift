//
//  AIVSAI.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//


import SwiftUI
import GoogleGenerativeAI

struct AIVSAI: View {
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State private var messages = [GeminiMessage]()
    
    //    @State private var user1 = ""
    //    @State private var user2 = ""
    @State private var user1 = "Student"
    @State private var user2 = "Teacher"
    
    
    
    //    @State private var users = ["Not defined", "Not defined"]
    @State private var users = ["Student", "Teacher"]
    
    //    @State private var selectedUser = "{}"
    @State private var selectedUser = "Student"
    
    //    @State private var firstMessage = ""
    @State private var firstMessage = "Hello, can i ask a question?"
    
    @State private var generating = false
    @State private var AIResponse = ""
    
    let initalPrompt = "Below is a chat history. Just generate the response."
    
    let modelManager = ModelManager()
    
    @State private var hideSetting = false
    
    @State private var currMessageID = UUID()
    var canStartConv: Bool {
        !user1.isEmpty && !user2.isEmpty && !firstMessage.isEmpty && selectedUser != "{}"
    }
    
    func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(currMessageID, anchor: .bottom)
        }
    }
    
    func scrollToBottom2() {
        withAnimation {
            scrollProxy?.scrollTo(messages.last?.id, anchor: .bottom)
        }
    }
    
    var body: some View {
        
        VStack{
            
            AIVSAISetting(user1: $user1, user2: $user2, users: $users, selectedUser: $selectedUser, firstMessage: $firstMessage, hide: $hideSetting).padding(.top)
            
            
            HStack{
                Spacer()
                
                Button {
                    messages = []
                } label: {
                    Label("Clear Chat History", systemImage: "xmark.circle")
                }
            }.padding()
            
            HStack{
                
                Button {
                    if messages.count == 0 {
                        hideSetting = true
                        let newMessage = GeminiMessage(user: selectedUser, message: firstMessage)
                        messages.append(newMessage)
                    } else {
                        hideSetting = true
                        getAIResponse()
                    }
                    
                } label: {
                    VStack{
                        if generating {
                            ProgressView()
                        } else {
                            Text("Generate next conversation").disabled(!canStartConv)
                        }
                    }
                }
                
                
                
                
            }
            
            
            
            
            
            
        }
        
        ScrollView {
            ScrollViewReader { proxy in
                VStack{
                    ForEach(messages, id: \.self) { currMessage in
                        MessageView(name: currMessage.user, messageText: currMessage.message, order: users.firstIndex(of: currMessage.user)!).id(currMessage.id)
                    }.onAppear {
                        scrollProxy = proxy
                    }
                    Spacer()
                }
            }
        }.padding([.top, .bottom])
            .onChange(of: messages) { oldValue, newValue in
                scrollToBottom()
                scrollToBottom2()
            }
    }
    
    func findOtherString(givenString: String) -> String {
        
        if users[0] == givenString {
            return users[1]
        } else {
            return users[0]
        }
    }
    
    func constuctPrompt() -> [String] {
        
        
        var res = ""
        
        for example in messages.sorted(by: { $0.date < $1.date}) {
            let curr = "\(example.user): \(example.message)\n"
            res+=curr
        }
        
        let lastOne = messages.sorted(by: { $0.date < $1.date}).last
        
        let lastUser = findOtherString(givenString: lastOne!.user)
        
        res += "\(lastUser):"
        
        return [res, lastUser]
    }
    
    
    func cutOffString(after word: String, in string: String) -> String {
        if let range = string.range(of: word) {
            print("message cutted off")
            return String(string[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return string
        }
    }
    
    func removeWord(_ word: String, from string: String) -> String {
        guard let range = string.range(of: word) else {
            // If the word is not found, return the original string
            return string
        }
        print("Start removed")
        return string.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    func getAIResponse() {
        AIResponse = ""
        generating = true
        
        var AI_response = ""
        let data = constuctPrompt()
        let prompt = data[0]
        let userToReply = data[1]
        
        modelManager.generateStringSteam(prompt: initalPrompt + prompt, onChunkReceived: { chunk in
            AI_response += chunk
            DispatchQueue.main.async {
                AIResponse = AI_response
            }
        }, completion: { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error generating content: \(error.localizedDescription)")
                } else {
                    print("Streaming complete.")
                }
                
                print(AIResponse)
                
                let cutOff = findOtherString(givenString: userToReply)
                AIResponse = removeWord("\(userToReply):", from: AIResponse)
                AIResponse = cutOffString(after: "\(cutOff):", in: AIResponse)
                let newOne = GeminiMessage(user: userToReply, message: AIResponse)
                currMessageID = newOne.id
                messages.append(newOne)
                generating = false
                AI_response = ""
            }
            
        })
    }
}
