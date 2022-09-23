//
//  StoryBodyView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import Combine
import CoreData
import SwiftUI

struct PromptEditorView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGeneration
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismissAddStory
    
    @FocusState private var isInputActive: Bool
    
//    @StateObject var loginVM = LoginViewModel()
//    @Binding var hadLaunched: Bool
    @State private var explainerContent: Explainer = .themeExplainer
    @State private var isShowingThemePopover: Bool = false
    @State private var isShowingPremisePopover: Bool = false
    @State private var isShowingBannedPopover: Bool = false
    @State private var alertUser: Bool = false
    @State private var isCommonTheme: Bool = false
    @State private var showingThemeOptions = false
    
    @State private var theme: String = ""
    @State private var setTheme: CommonTheme? = nil
    @State private var setGenre: CommonGenre? = nil
    @State private var bannedWord: String = ""
    @State private var showingStoryTellerScreen = false
    @State private var message: String = ""
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let themePlaceholder: String = "Type the theme here or choose a common one ⬇️."
    let premisePlaceholder: String = "Type the premise here"
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
                    TextField(themePlaceholder, text: $theme) // use onChange to update the placeholder
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.custom("Futura", size: 15)) // use either Futura, Caslon, or Johnston-the London underground typeface
                        .onReceive(Just(theme)) { _ in limitText(textLimit) }
                    
                        ThemePickerView(themeChoices: $setTheme)
                            .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Theme_")
                            .font(.custom("Futura", size: 17))
                        
                        // popover with instructional information
                        Button {
                            self.explainerContent = .themeExplainer
                            isShowingThemePopover.toggle()
                            if isShowingThemePopover {
                                isShowingPremisePopover = false
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingThemePopover) {
                            PopoverTextView(mainPopover: $explainerContent)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Section {
                    TextEditorView(placeholder: premisePlaceholder, text: $textGeneration.primary.text, title: $title)
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.custom("Futura", size: 15))
                        .onReceive(Just(textGeneration.primary.text)) { _ in limitText(textLimit) }
                        .onChange(of: textGeneration.primary.text) { _ in detector.send() }
                        .onReceive(publisher) { save() }
                    
                    GenrePickerView(genreChoices: $setGenre)
                        .padding(.trailing)
                } header: {
                    HStack {
                        Text("_Premise_")
                            .font(.custom("Futura", size: 17))

                        // popover with instructional information
                        Button {
                            self.explainerContent = .premiseExplainer
                            isShowingPremisePopover.toggle()
                            if isShowingPremisePopover {
                                isShowingThemePopover = false
                            }
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .popover(isPresented: $isShowingPremisePopover) {
                            PopoverTextView(mainPopover: $explainerContent)
                        } 
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                           // TODO: need to make sure this is added once, maybe use boolean
                           let text = promptDesign(theme, textGeneration.primary.text)
                           textGeneration.getTextResponse(moderated: false, sessionStory: text)
                           showingStoryTellerScreen.toggle()
       //                    UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                        }
                        .buttonStyle(SendButton())
                    }
                }
            }
            // next screen of adding a book review is shown when showingAddScreen is true
            .sheet(isPresented: $showingStoryTellerScreen) {
                StoryEditorView()
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
        var theTheme: String = setTheme?.id ?? ""
        var theGenre: String = setGenre?.id ?? ""
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
        Seventy-Sentence \(theGenre) Story: \(storyPrompt)
        """
//        "The following is a conversation with a " + mainDescription
//            + ". " + "This " + mainDescription + " is" + adjectives + "."
//        Horror Story: He always stops crying when I pour the milk on his cereal. I just have to remember not to let him see his face on the carton (the "." is the stop sequence)
        return prompt
    }
}
