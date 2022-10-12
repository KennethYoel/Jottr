//
//  TextCompletion.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/29/22.
//

import Combine
import Foundation
import SwiftUI

@MainActor class TxtComplViewModel: ObservableObject {
//    @Published private(set) var state = State.idle
    @Published var title: String
    @Published var promptLoader: String
    @Published var sessionStory: [SessionStory]
    @Published var setTheme: CommonTheme
    @Published var setGenre: CommonGenre
    @Published var loading: Bool
    @Published var failed: Bool
    @Published var errorMessage: String = ""
    
    var primary: SessionStory {
        get {
            if sessionStory.isEmpty {
                return SessionStory.init(id: UUID(), text: "")
            }
            return sessionStory[0]
        }
        set(newStory) {
            sessionStory = [newStory]
        }
    }
    
    init() {
        self.title = ""
        self.promptLoader = ""
        self.sessionStory = [SessionStory]()
        self.setTheme = .custom
        self.setGenre = .fantasy
        self.loading = false
        self.failed = false
    }
    
    func getTextResponse(moderated: Bool, sessionStory: String) async {
        loading.toggle()
        
        var promptText: String = ""
        if sessionStory.isEmpty {
            promptText = self.primary.text
        } else {
            promptText = sessionStory
        }
        
        do {
            try await handleResponse(withModeration: moderated, textForPrompt: promptText)
        } catch let error as CustomError {
            loading.toggle()
            failed.toggle()
            switch error {
            case .failCodableResponse:
                errorMessage = CustomError.failCodableResponse.stringValue()
            default:
                errorMessage = error.localizedDescription
                break
            }
        } catch {
            debugPrint(error)
        }
    }
    
    // handles the return data from OpenAI API
    func handleResponse(withModeration: Bool, textForPrompt: String) async throws {
        let openaiResponse = await OpenAIConnector.loadText(with: withModeration, sessionPrompt: textForPrompt)
        
        guard let data = openaiResponse else {
            throw CustomError.failCodableResponse
        }
        let newText = data.choices[0].completionText
        self.appendToStory(sessionStory: newText)
        loading.toggle()
        //        DispatchQueue.main.async {
        //            self.state = .loaded(completedText) no longer need DispatchQueue weil using MainActor
        //        }
    }
    
    func promptDesign(_ mainTheme: String = "", _ storyPrompt: String) -> String {
        var theTheme: String = ""
        let theGenre: String = setGenre.id
        
        if setTheme.id == "Custom" {
            theTheme = mainTheme
        } else {
            theTheme = setTheme.id
        }
        
        let prompt = """
        Topic: Breakfast
        Two-Sentence Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to
        let him see his face on the carton.
        
        Topic: \(theTheme)
        Seventy-Sentence \(theGenre) Story: \(storyPrompt)
        """
        
        return prompt
    }
    
    func appendToStory(sessionStory: String) {
        if self.sessionStory.isEmpty {
            // concatenate the next part of the generated story onto the existing story
            self.primary.text += promptLoader + sessionStory
        } else {
            self.primary.text += sessionStory
        }
    }
}

//  check whether the array is containing the requested index before accessing the index, if not then nil
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
