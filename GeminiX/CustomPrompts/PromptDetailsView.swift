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
                    print(childNames)
                }
            }
            
            VStack{
                ForEach($childNames.indices, id: \.self) { index in
                    TextField("\(childNames[index])", text: $childNames[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            
            
            Button {
                //
            } label: {
                Text("Generate Resonse")
            }

            
            Text(response)
            
            
            
        }.onAppear{
            promptName = prompt.name
            parentPrompt = prompt.parentPrompt
        }
    }
    
    func extractPlaceholders(input: String) -> [String] {
        let pattern = "\\{(.*?)\\}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        
        return results.map {
            String(input[Range($0.range(at: 1), in: input)!])
        }
    }
    
    //    func save() {
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Saving failed - error happend at PromptDetailsView")
    //        }
    //    }
}
