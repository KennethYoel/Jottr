//
//  ModerationResponse.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import Foundation

struct ModerationResponse: Decodable, Identifiable {
    let id: String
    let model: String
    let results: [Results]
}

struct Results: Decodable {
    struct Categories: Decodable {
        let hate: Bool
        let hateThreatening: Bool
        let selfHarm: Bool
        let sexual: Bool
        let sexualMinors: Bool
        let violence: Bool
        let violenceGraphic: Bool
        
        enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case selfHarm = "self-harm"
            case sexual
            case sexualMinors = "sexual/minors"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
    struct CategoryScores: Decodable {
        let hate: Double
        let hateThreatening: Double
        let selfHarm: Double
        let sexual: Double
        let sexualMinors: Double
        let violence: Double
        let violenceGraphic: Double
        
        enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case selfHarm = "self-harm"
            case sexual
            case sexualMinors = "sexual/minors"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
    
    let categories: Categories
    let categoryScores: CategoryScores
    let flagged: Bool
    
    enum CodingKeys: String, CodingKey {
        case categories
        case categoryScores = "category_scores"
        case flagged
    }
}

/*
 {
    "id": "cmpl-5dheWJpxgUMBuLbsAXBwwehfYD28m",
    "object": "text_completion",
    "created": 1660144276,
    "model": "text-davinci-002",
    "choices": [
    {
        "text": ".\n\nThis is a test.",
        "index": 0,
        "logprobs": nil,
        "finish_reason": "stop"
    }
  ]
 }
 
 {
   "id": "modr-XXXXX",
   "model": "text-moderation-001",
   "results": [
     {
       "categories": {
         "hate": 0, <- this is a Bool
         "hate/threatening": 0, <- this is a Bool
         "self-harm": 0, <- this is a Bool
         "sexual": 0, <- this is a Bool
         "sexual/minors": 0, <- this is a Bool
         "violence": 0, <- this is a Bool
         "violence/graphic": 0 <- this is a Bool
       },
       "category_scores": {
         "hate": 0.18805529177188873,
         "hate/threatening": 0.0001250059431185946,
         "self-harm": 0.0003706029092427343,
         "sexual": 0.0008735615410842001,
         "sexual/minors": 0.0007470346172340214,
         "violence": 0.0041268812492489815,
         "violence/graphic": 0.00023186142789199948
       },
       "flagged": 0 <- this is a Bool
     }
   ]
 }
 */
