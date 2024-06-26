//
//  ModelManager.swift
//  GeminiX
//
//  Created by SeungJun Lee on 4/27/24.
//

import Foundation
import GoogleGenerativeAI
import UIKit

class ModelManager {
    private var model: GenerativeModel
    private var imageModel: GenerativeModel
    
    init() {
        self.model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
        self.imageModel = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    }
    
    func askImageQuestion(prompt: String, image1: UIImage) async -> String {
        var result = ""
        do {
            let response = try await imageModel.generateContent("prompt", image1)
            if let text = response.text {
                print(text)
                result = text
            }
            return result
        } catch {
            print("An error occurred: \(error)")
            return "An error occurred while processing the image."
        }
    }
    
    func generateString(from prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    DispatchQueue.main.async {
                        completion(.success(text))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "ContentGenerationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No text returned from the model"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func chatMode(prompt: String, history: [ModelContent], completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let chat = model.startChat(history: history)
                let response = try await chat.sendMessage(prompt)
                if let text = response.text {
                    DispatchQueue.main.async {
                        completion(.success(text))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "ContentGenerationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No text returned from the model"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func chatModeStream(prompt: String, history: [ModelContent], onChunkReceived: @escaping (String) -> Void, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                let chat = model.startChat(history: history)
                let contentStream = chat.sendMessageStream(prompt)
                for try await chunk in contentStream {
                    if let text = chunk.text {
                        DispatchQueue.main.async {
                            onChunkReceived(text)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    
    func generateStringSteam(prompt: String, onChunkReceived: @escaping (String) -> Void, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                let contentStream = model.generateContentStream(prompt)
                for try await chunk in contentStream {
                    if let text = chunk.text {
                        DispatchQueue.main.async {
                            onChunkReceived(text)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}

