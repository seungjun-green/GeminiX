//
//  SwiftData.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import SwiftData

@Model
class Chat {
    @Attribute(.unique) var date: Date
    var name: String
    var details = [ChatDetails]()
 
    
    init(date: Date, name: String, details: [ChatDetails] = [ChatDetails]()) {
        self.date = date
        self.name = name
        self.details = details
    }
}

@Model
class ChatDetails {
    var uuid = UUID()
    var date = Date()
    var message: String
    var isHuman: Bool
    
    init(uuid: UUID = UUID(), message: String, isHuman: Bool) {
        self.uuid = uuid
        self.message = message
        self.isHuman = isHuman
    }
}

@Model
class CustomPrompts {
    var id = UUID()
    var name: String
    var date = Date()
    var parentPrompt = ""
    var childPrompts = [String]()
  
    init(id: UUID = UUID(), name: String, date: Date = Date(), parentPrompt: String = "", childPrompts: [String] = [String]()) {
        self.id = id
        self.name = name
        self.date = date
        self.parentPrompt = parentPrompt
        self.childPrompts = childPrompts
    }
}
