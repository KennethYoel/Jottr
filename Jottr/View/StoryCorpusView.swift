//
//  StoryBodyView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import Combine
import SwiftUI

struct StoryCorpusView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGenerationStore
//    @StateObject var loginVM = LoginViewModel()
//    @Binding var hadLaunched: Bool
    @State var currentView: String = "firstPage"
    @State private var isShowingPopover: Bool = false
    
    let premisePlaceholder: String = """
    Start with the premise, which is your entire story condensed to a single sentence
    
    E.g. "Three people tell conflicting versions of a meeting that changed the outcome of World War II."
    """
    let scribblePlaceholder: String = """
    Influence your AI writing style with directions.
    
    E.g. "Use a very descriptive writing style in 17th century language."
    """
    let bannedPlaceholder: String = " Add a word or words to ban."
    
    @State private var premise: String = ""
    @State private var bannedWord: String = ""
    @State var showingStoryTellerScreen = false
    let textLimit = 350
    let detector = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<Void, Never>
    
    init() {
        publisher = detector
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
//    let banner = """
//              __,
//             (           o  /) _/_
//              `.  , , , ,  //  /
//            (___)(_(_/_(_ //_ (__
//                         /)
//                        (/
//            """
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                HStack {
                    Text("**Premise**")
                        .padding(.leading)
                    Button("Show Popover", action: {
                        self.isShowingPopover = true
                    })
                        .popover(isPresented: $isShowingPopover) {
                        PopoverView()
//                        Text("Your content here")
//                            .font(.headline)
//                            .padding()
                    }
                }
                CustomTextEditor(placeholder: premisePlaceholder, text: $premise)
                    .border(Color.gray, width: 2)
                    .cornerRadius(11)
                    .foregroundColor(.primary)
                    .font(.custom("HelveticaNeue", size: 13))
                    .padding(.horizontal)
                    .onReceive(Just(premise)) { _ in limitText(textLimit) }
                
                Text("**Writer's Scribble**")
                    .padding(.leading)
                CustomTextEditor(placeholder: scribblePlaceholder, text: $textGeneration.primary.text)
                    .border(Color.black, width: 2)
                    .cornerRadius(11)
                    .foregroundColor(.primary)
                    .font(.custom("HelveticaNeue", size: 13))
                    .padding(.horizontal)
                    .onReceive(Just(textGeneration.primary.text)) { _ in limitText(textLimit) }
                    .onChange(of: textGeneration.primary.text) { _ in detector.send() }
                    .onReceive(publisher) { save() }
                
                Text("**Banned Words**")
                    .padding(.leading)
                TextField(bannedPlaceholder, text: $bannedWord)
                    .border(Color.black, width: 2)
                    .cornerRadius(11)
                    .foregroundColor(.primary)
                    .font(.custom("HelveticaNeue", size: 13))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Button("Do Write") {
                    // TODO: need to make sure this is added once, maybe use boolean
                    let text = promptDesign(premise, textGeneration.primary.text)
                    textGeneration.getTextResponse(moderated: false, sessionStory: text)
//                    UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                }
            }
            .transition(.opacity)
            .navigationTitle("Prompt Settings")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button("Write It?") {
                        // TODO: need to make sure this is added once, maybe use boolean
                        let text = promptDesign(premise, textGeneration.primary.text)
                        textGeneration.getTextResponse(moderated: false, sessionStory: text)
    //                    UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                        self.currentView = "firstPage"
    //                    self.hadLaunched = true
                        showingStoryTellerScreen.toggle()
                    }
    //                .buttonStyle(.bordered)
                    .tint(.indigo)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        // next screen of adding a book review is shown when showingAddScreen is true
        .sheet(isPresented: $showingStoryTellerScreen) { StoryTellerView() }
    }
    
    // MARK: Helper Methods
    
    private func save() {
        /*
         Solution: Using Combine with .debounce to publish and observe only
         after x seconds have passed with no further events.
         Must import Combine
         I have set x to 3sec.
         */
//        savedText = generationModel.primary.text
        print("primary sesionPrompt saved.")
    }
    
    //    // function to keep text length in limits
    private func limitText(_ upper: Int) {
        if premise.count & textGeneration.primary.text.count > upper {
            premise = String(premise.prefix(upper))
            textGeneration.sessionPrompt[0].text = String(textGeneration.primary.text.prefix(upper))
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

/*
 Code sample for a TextEditor with Placeholder functionality from cs4alhaider at
 https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui
 */
struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
        
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
               VStack {
                    Text(placeholder)
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.7)
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 150, maxHeight: 300)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
            .onTapGesture { hideKeyboard() }
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboard() {
        /*
        Solution: Adding a tap gesture to let users dismiss the keyboard when
        tapped outside of the TextEditor. Call save() at the same time.
        */
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PopoverView: View {
    var body: some View {
        Text("Popover Content")
            .padding()
    }
}
