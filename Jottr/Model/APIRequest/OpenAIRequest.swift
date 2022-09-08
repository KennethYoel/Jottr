//
//  OpenAIRequest.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/12/22.
//

import Foundation

struct Parameters: Encodable {
//    let model: String
    let prompt: String
    let maxTokens: Int
    let temperature: Int
//    let topP: Int
//    let n: Int
//    let stream: Bool
//    let logprobs: Int
//    let stop: String
    let user: String // = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
//        case model
        case prompt
        case maxTokens = "max_tokens"
        case temperature
//        case topP = "top_p"
//        case n
//        case stream
//        case logprobs
//        case stop
        case user
    }
}
/*
 A UUID is a universally unique identifier, which means if you generate a UUID right now using UUID it's guaranteed to be
 unique across all devices in the world. This means it's a great way to generate a unique identifier for users, for files, or
 anything else you need to reference individually – guaranteed.
 */

/*
 If using endpoint https://api.openai.com/v1/completions \ for choosing the model then {"model": "text-davinci-002", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 6}
 */

/*
 {
   "model": "text-davinci-002",
   "prompt": "Say this is a test",
   "max_tokens": 6,
   "temperature": 0,
   "top_p": 1,
   "n": 1,
   "stream": false,
   "logprobs": null,
   "stop": "\n"
 }

 */
