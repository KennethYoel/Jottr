//
//  StoryBodyView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import Combine
import CoreData
import SwiftUI

//enum CommonTheme: String, CaseIterable, Identifiable {
//    case  goodVsEvil, love, redemption, courageAndPerseverance, comingOfAge, revenge
//    
//    var id: String { self.rawValue }
//}

struct PromptEditorView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGeneration
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismissAddStory
    @FocusState private var isInputActive: Bool
    
//    @StateObject var loginVM = LoginViewModel()
//    @Binding var hadLaunched: Bool
    @State private var isShowingThemePopover: Bool = false
    @State private var isShowingPremisePopover: Bool = false
    @State private var alertUser: Bool = false
    @State private var isCommonTheme: Bool = false
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    var message: String = ""
    
    let themePlaceholder: String = """
    Start with a topic, which is the central idea.
    
    E.g. "What comes around, goes around."
    """
    let premisePlaceholder: String = """
    Start with the premise, which is your entire story condensed to a single sentence
        
    E.g. "Three people tell conflicting versions of a meeting that changed the outcome of World War II."
    
    Influence your AI writing style with directions.
    
    E.g. "Use a very descriptive writing style in 17th century language."
    """
    let bannedPlaceholder: String = " Add a word or words to ban."
    
    @State private var theme: String = ""
    @State private var setTheme: CommonTheme? = nil
    @State private var showingThemeOptions = false
    @State private var selection = "None"
    
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
        NavigationView {
            Form {
                Section {
                    CustomTextEditor(placeholder: themePlaceholder, text: $theme)
                        .focused($isInputActive)
    //                    .cornerRadius(11)
                        .foregroundColor(.primary)
                        .font(.custom("HelveticaNeue", size: 13))
//                        .padding(.horizontal)
                        .onReceive(Just(theme)) { _ in limitText(textLimit) }
                    
                    ThemePicker(themeChoices: $setTheme)
                        .padding()
                } header: {
                    HStack {
                        Text("_Theme_")
//                            .padding(.leading)
                        
                        // popover with instructional information
                        Button {
                            self.isShowingThemePopover = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingThemePopover) { PopoverThemeView() }
                    }
                }
                
                Section {
                    CustomTextEditor(placeholder: premisePlaceholder, text: $textGeneration.primary.text)
                        .focused($isInputActive)
    //                    .cornerRadius(11)
                        .foregroundColor(.primary)
                        .font(.custom("HelveticaNeue", size: 13))
//                        .padding(.horizontal)
                        .onReceive(Just(textGeneration.primary.text)) { _ in limitText(textLimit) }
                        .onChange(of: textGeneration.primary.text) { _ in detector.send() }
                        .onReceive(publisher) { save() }
                } header: {
                    HStack {
                        Text("_Premise_")
//                            .padding(.leading)

                        // popover with instructional information
                        Button {
                            self.isShowingPremisePopover = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingPremisePopover) { PopoverPremiseView() }
                    }
                }
                
                Section {
                    TextField(bannedPlaceholder, text: $bannedWord)
                        .border(Color.black, width: 2)
    //                    .cornerRadius(11)
                        .foregroundColor(.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .padding(.horizontal)
                        .padding(.bottom)
                } header: {
                    Text("_Banned Words_")
                        .padding(.leading)
                }
                
                Section {
                    Button("Do Write") {
                       // TODO: need to make sure this is added once, maybe use boolean
                       let text = promptDesign(theme, textGeneration.primary.text)
                       textGeneration.getTextResponse(moderated: false, sessionStory: text)
                       showingStoryTellerScreen.toggle()
   //                    UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                   }
                   .buttonStyle(.bordered)
                   .tint(.indigo)
//                 .buttonStyle(.borderedProminent)
                }
            }
            // next screen of adding a book review is shown when showingAddScreen is true
            .sheet(isPresented: $showingStoryTellerScreen) {
                StoryEditorView(currentView: .constant(.storyEditor))
            }
            .alert(title, isPresented: $alertUser, presenting: message) {_ in
                Button("OK") {}
            }
            .transition(.opacity)
            .navigationTitle("Prompt Editor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismissAddStory()
                    }
                    .buttonStyle(.plain)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        hideKeyboardAndSave()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
   }
    
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
        if theme.count & textGeneration.primary.text.count > upper {
            theme = String(theme.prefix(upper))
            textGeneration.sessionPrompt[0].text = String(textGeneration.primary.text.prefix(upper))
        }
    }
    
    func promptDesign(_ mainTheme: String = "", _ storyPrompt: String) -> String {
        var theTheme: String = setTheme?.stringComparisons ?? ""
//        // Six common themes in literature are:
//        switch themeChoices {
//        case .goodVsEvil:
//            theTheme = themeChoices.rawValue
//        case .love:
//            theTheme = themeChoices.rawValue
//        case .redemption:
//            theTheme = themeChoices.rawValue
//        case .courageAndPerseverance:
//            theTheme = themeChoices.rawValue
//        case .comingOfAge:
//            theTheme = themeChoices.rawValue
//        case .revenge:
//            theTheme = themeChoices.rawValue
//        }
        
        if !isCommonTheme {
            theTheme = mainTheme
        }
        
        let prompt = """
        Topic: \(theTheme)
        Seventy-Sentence Fantasy Story: \(storyPrompt)
        """
//        "The following is a conversation with a " + mainDescription
//            + ". " + "This " + mainDescription + " is" + adjectives + "."
//        Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to let him see his face on the carton (the "." is the stop sequence)
        return prompt
    }
}
