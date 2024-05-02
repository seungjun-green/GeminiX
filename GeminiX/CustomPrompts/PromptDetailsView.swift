//
//  PromptDetailsView.swift
//  GeminiX
//
//  Created by SeungJun Lee on 5/1/24.
//

import SwiftUI
import SwiftData

struct PromptDetailsView: View {
    var modelManager: ModelManager
    @Bindable var prompt: CustomPrompts
    @Environment(\.modelContext) var context
    
    @State private var promptName = ""
    @State private var parentPrompt = ""
    @State private var childPrompts = [String]()
    @State private var childNames = [String]()
    
    @State private var response = ""
    
    @State private var hideChilds = false
    @State private var generating = false
    
    @State private var titleEdit = false
    @State private var textCopied = false
    
    
    
    var body: some View {
        ScrollView{
            
            
            HStack(alignment: .center) {
                if titleEdit {
                    TextField("Name", text: $promptName)
                        .font(.largeTitle)
                        .onChange(of: promptName) { oldValue, newValue in
                            prompt.name = promptName
                        }
                } else {
                    Text(promptName).font(.largeTitle)
                }
                
                Button {
                    titleEdit.toggle()
                } label: {
                    if titleEdit {
                        Image(systemName: "checkmark") .font(.title)
                    } else {
                        Image(systemName: "pencil") .font(.title)
                    }
                }
                
                Spacer()
            }.padding([.top, .horizontal])
            
            
            
            Divider()
            
            
            VStack{
                HStack{
                    Text("Parent's Prompt").font(.title2).fontWeight(.medium)
                    Spacer()
                }
                TextField("Parent Prompt", text: $parentPrompt, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: parentPrompt) { oldValue, newValue in
                        prompt.parentPrompt = parentPrompt
                        childNames = extractPlaceholders(input: parentPrompt)
                    }
            }.padding(.horizontal)
            
            
           
            
            VStack{
                ForEach($childNames.indices, id: \.self) { index in
                    
                    VStack{
                        
                        
                        HStack{
                            Text("- \(childNames[index])").font(.title3)
                            Spacer()
                        }
                        
                        TextField("\(childPrompts[index])", text: $childPrompts[index], axis: .vertical)
                            .lineLimit(7)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }.padding(.horizontal)
                    
                }
            }.onChange(of: childPrompts) { oldValue, newValue in
                prompt.childPrompts = childPrompts
            }
            
            
            
            
            Button {
                generating = true
                print(replacePlaceholders(template: parentPrompt, values: childPrompts))
                let prompt = replacePlaceholders(template: parentPrompt, values: childPrompts)
                
                modelManager.generateString(from: prompt) { result in
                    switch result {
                    case .success(let text):
                        print(text)
                        response = text
                        generating = false
                    case .failure(let error):
                        print("Error generating content: \(error.localizedDescription)")
                        generating = false
                    }
                }
                
            } label: {
                VStack{
                    if generating {
                        ProgressView().frame(height: 50)
                    } else {
                        Text("Generate Resonse")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .frame(height: 50)
                    }
                }.padding(.top)
                
            }
            
            
            VStack{
                HStack{
                    Text("Result").font(.title3).fontWeight(.medium)
                    Spacer()
                    
                    
                    Button {
                        UIPasteboard.general.string =  response
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

                }
                
                TextField("", text: $response, axis: .vertical)
                    .lineLimit(7)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding(.horizontal)
            
            
            
            
            
            
            
        }.onAppear{
            promptName = prompt.name
            parentPrompt = prompt.parentPrompt
            childNames = extractPlaceholders(input: parentPrompt)
            
            
            childPrompts = prompt.childPrompts
            
            
            if childPrompts.isEmpty {
                childPrompts = childNames
                prompt.childPrompts = childPrompts
                
            }
        }
        
        
    }
    
    func replacePlaceholders(template: String, values: [String]) -> String {
        let pattern = "\\{(.*?)\\}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(template.startIndex..<template.endIndex, in: template)
        
        let matches = regex.matches(in: template, options: [], range: nsrange)
        var result = template
        
        for (index, match) in matches.reversed().enumerated() {
            guard index < values.count else { break }
            let matchRange = Range(match.range, in: template)!
            result.replaceSubrange(matchRange, with: values[index])
        }
        
        return result
    }
    
    
    func extractPlaceholders(input: String) -> [String] {
        let pattern = "\\{(.*?)\\}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        
        return results.map {
            String(input[Range($0.range(at: 1), in: input)!])
        }
    }
    
}
