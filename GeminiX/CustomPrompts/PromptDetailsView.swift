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
    @State private var childPrompt1 = ""
    @State private var childPrompt2 = ""
    @State private var childPrompt3 = ""
    @State private var childPrompt4 = ""
    @State private var childPrompt5 = ""
    @State private var childPrompt6 = ""
    @State private var childPrompt7 = ""
    @State private var childPrompt8 = ""
    @State private var childPrompt9 = ""
    @State private var childPrompt10 = ""
    
    @State private var childPrompts = [String]()
    @State private var childNames = [String]()
    
    @State private var response = ""
    
    var body: some View {
        VStack{
            
            VStack{
                Text("Prompt Name")
                TextField("Name", text: $promptName).onChange(of: promptName) { oldValue, newValue in
                    prompt.name = promptName
                }
            }
            
            
            VStack{
                Text("Parent's Prompt")
                TextField("Parent Prompt", text: $parentPrompt, axis: .vertical).onChange(of: parentPrompt) { oldValue, newValue in
                    prompt.parentPrompt = parentPrompt
                    childNames = extractPlaceholders(input: parentPrompt)
                }
            }
            
            VStack{
                ForEach($childNames.indices, id: \.self) { index in
                    
                    VStack{
                        
                        Text(childNames[index])
                        TextField("\(childPrompts[index])", text: $childPrompts[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                }
            }.onChange(of: childPrompts) { oldValue, newValue in
                prompt.childPrompts = childPrompts
            }
            
            
            Button {
                //
                print(replacePlaceholders(template: parentPrompt, values: childPrompts))
                let prompt = replacePlaceholders(template: parentPrompt, values: childPrompts)
                
                modelManager.generateString(from: prompt) { result in
                    switch result {
                    case .success(let text):
                        print(text)
                        response = text
                    case .failure(let error):
                        print("Error generating content: \(error.localizedDescription)")
                    }
                }
                
            } label: {
                Text("Generate Resonse")
            }
            
            
            Text(response)
            
            
            
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
