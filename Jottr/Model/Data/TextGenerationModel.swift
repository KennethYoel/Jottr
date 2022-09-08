//
//  TextCompletion.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/29/22.
//

import Foundation

class TextGenerationModel: ObservableObject {
    @Published var sessionPrompt = [SessionPrompt]()
    @Published var story: String = ""
    
    var primary: SessionPrompt {
        get {
            if sessionPrompt.isEmpty {
                return SessionPrompt.init(id: UUID(), text: "")
            }
            return sessionPrompt[0]
        }
        set(newPrompt) {
            self.sessionPrompt.append(newPrompt)
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
                    self.story += self.appendToStory(story: self.story, sessionStory: newText)
                }
        case .failure(let error):
            print(error.localizedDescription)
//            handleFailureAlert(title: "Error", message: error.localizedDescription)
        }
    }

//    func handleFailureAlert(title: String, message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alertVC, animated: true, completion: nil)
//    }
    
    func appendToStory(story: String, sessionStory: String) -> String {
        var storySoFar: String = "" // this works!!!!
        if storySoFar == "" {
            // concatenate the next part of the generated story onto the existing story
            storySoFar += self.primary.text + sessionStory
        } else {
            storySoFar += sessionStory
        }
        
        return storySoFar
    }
}

//  check whether the array is containing the index before accessing the index, if not then nil
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}