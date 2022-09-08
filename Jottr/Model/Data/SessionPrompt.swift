//
//  PromptTexts.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/6/22.
//

import Foundation

struct SessionPrompt: Decodable, Identifiable, Hashable {
    var id = UUID()
    var text: String
}
