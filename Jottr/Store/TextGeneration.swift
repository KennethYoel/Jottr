//
//  TextCompletion.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/29/22.
//

import Foundation

class TextGeneration: ObservableObject {
    @Published var sessionPrompt = [SessionPrompt]()
    @Published var title: String = ""
    @Published var sessionStory: String = ""
    
    var primary: SessionPrompt {
        get {
            if sessionPrompt.isEmpty {
                return SessionPrompt.init(id: UUID(), text: "")
            }
            return sessionPrompt[0]
        }
        set(newPrompt) {
            sessionPrompt = [newPrompt]
        }
        
        // unwrap a optional array, if array doesn't have a 0th index then init an empty text
//        guard let unwrappedText = textCompletion[safe: 0] else {
//            return Texts.init(id: UUID(), text: "", fromUser: false)
//        }
//        return unwrappedText
    }
    
    func getTextResponse(moderated: Bool, sessionStory: String) {
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
            }
        case .failure(let error):
//            print(error.localizedDescription)
            handleFailureAlert(title: "Error", message: error.localizedDescription)
        }
    }

    func handleFailureAlert(title: String, message: String) {
        var showAlert = AlertView()
        showAlert.title = title
        showAlert.message = message
    }
    
    func appendToStory(sessionStory: String) {
        if self.sessionStory.isEmpty {
            // concatenate the next part of the generated story onto the existing story
            self.sessionStory += primary.text + sessionStory
        } else {
            self.sessionStory += sessionStory
        }
    }
}

//  check whether the array is containing the requested index before accessing the index, if not then nil
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
