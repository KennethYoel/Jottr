//
//  StoryBodyView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import Combine
import SwiftUI

struct InitialView: View {
    // MARK: Properties
    
    @EnvironmentObject var generationModel: TextGenerationModel
//    @StateObject var loginVM = LoginViewModel()
    @Binding var hadLaunched: Bool
    @State var currentView: String = "firstPage"
    @State var mainTopic: String = ""
    let textLimit = 350
    
//    let banner = """
//              __,
//             (           o  /) _/_
//              `.  , , , ,  //  /
//            (___)(_(_/_(_ //_ (__
//                         /)
//                        (/
//            """
    
    var body: some View {
        if(!hadLaunched) {
            VStack {
                TextEditor(text: $mainTopic) // "Topic?",
                    .onReceive(Just(mainTopic)) { _ in limitText(textLimit) }
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .navigationTitle("Start your story...")
                TextEditor(text: $generationModel.primary.text) // out of index to set a default value
                    .frame(width: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onReceive(Just(generationModel.primary.text)) { _ in limitText(textLimit) }
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .transition(.opacity)
            .navigationTitle("🖋Jottr")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button("Write It?") {
                        let text = promptDesign(mainTopic, generationModel.primary.text)
                        generationModel.getTextResponse(moderated: false, sessionStory: text)
                        UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                        self.currentView = "firstPage"
                        self.hadLaunched = true
                    }
    //                .buttonStyle(.bordered)
                    .tint(.indigo)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    // MARK: Helper Methods
    //    // function to keep text length in limits
    func limitText(_ upper: Int) {
        if mainTopic.count & generationModel.primary.text.count > upper {
            mainTopic = String(mainTopic.prefix(upper))
            generationModel.sessionPrompt[0].text = String(generationModel.primary.text.prefix(upper))
        }
    }
    
    func promptDesign(_ mainTopic: String, _ storyPrompt: String) -> String {
        let prompt = """
        Topic: \(mainTopic)
        Seventy-Sentence Fantasy Story: \(storyPrompt)
        """
//        "The following is a conversation with a " + mainDescription
//            + ". " + "This " + mainDescription + " is" + adjectives + "."
//        Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to let him see his face on the carton (the "." is the stop sequence)
        return prompt
    }
}
