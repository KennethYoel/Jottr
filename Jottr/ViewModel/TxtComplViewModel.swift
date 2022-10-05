//
//  TextCompletion.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/29/22.
//

import Foundation

class TxtComplViewModel: ObservableObject {
    enum LoadingAPIState {
        case loading
        case loaded
        case failed(Error)
    }
    
    @Published private(set) var loadingAPIState = LoadingAPIState.loaded
    
    @Published var title: String = ""
    @Published var sessionPrompt: String = ""
    @Published var sessionStory = [SessionStory]()
    @Published var setTheme: CommonTheme = .custom
    @Published var setGenre: CommonGenre = .fantasy
    
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
        
        // unwrap a optional array, if array doesn't have a 0th index then init an empty text
//        guard let unwrappedText = textCompletion[safe: 0] else {
//            return Texts.init(id: UUID(), text: "", fromUser: false)
//        }
//        return unwrappedText
    }
    
    func getTextResponse(moderated: Bool = true, sessionStory: String) {
        loadingAPIState = .loading
        
        var promptText: String = ""
        if sessionStory.isEmpty {
            promptText = self.primary.text
        } else {
            promptText = sessionStory
        }
        
        handlePromptResponse(withModeration: moderated, textForPrompt: promptText)
    }
    
    // handles the return data from OpenAI API
    func handlePromptResponse(withModeration: Bool, textForPrompt: String) {
        if !withModeration {
            OpenAIConnector.processPrompt(prompt: textForPrompt, completionHandler: handlePromptResults(stringResults:))
        } else if withModeration {
            OpenAIConnector.processModeratePrompt(prompt: textForPrompt, completionHandler: handlePromptResults(stringResults:))
        }
    }
    
    func handlePromptResults(stringResults: Result<OpenAIResponse?, Error>) {
        switch stringResults {
        case .success(let data):
            guard let data = data else {
                return
            }
            let newText = data.choices[0].completionText
            DispatchQueue.main.async {
                self.appendToStory(sessionStory: newText)
                self.loadingAPIState = .loaded
            }
        case .failure(let error):
            loadingAPIState = .failed(error)
        }
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
        Topic: \(theTheme)
        Seventy-Sentence \(theGenre) Story: \(storyPrompt)
        """
        
        return prompt
    }
    
    func appendToStory(sessionStory: String) {
        if self.sessionStory.isEmpty {
            // concatenate the next part of the generated story onto the existing story
            self.primary.text += sessionPrompt + sessionStory
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
