//
//  OpenAIResponse.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import Foundation

struct OpenAIResponse: Decodable, Identifiable {
    let id: String // since the json data has an id property we can use Identifiable to know if it is unique
    let object: String
    let created: Int
    let model: String
    
    struct Choice: Decodable {
        let completionText: String
        let index: Int
        let logprobs: String?
        let finishReason: String
        
        enum CodingKeys: String, CodingKey {
            case completionText = "text"
            case index
            case logprobs
            case finishReason = "finish_reason"
        }
    }
    
    let choices: [Choice]
    
    struct Usage: Decodable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
    
    let usage: Usage
}
