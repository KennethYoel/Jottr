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
    
    @EnvironmentObject var textGeneration: GenTextViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismissEditPrompt
    //    @Binding var hadLaunched: Bool
    
    @FocusState private var isInputActive: Bool
    
//    @StateObject var loginVM = LoginViewModel()

    @State private var explainerContent: Explainer = .themeExplainer
    @State private var isShowingThemePopover: Bool = false
    @State private var isShowingPremisePopover: Bool = false
    @State private var isShowingBannedPopover: Bool = false
    
    @State private var alertUser: Bool = false
    @State private var message: String = ""
    
    @State private var theme: String = ""
    @State private var showingStoryEditorScreen = false
    
    @State private var title = ""
    @State private var genre = ""
    @State private var review = ""
    
    let themePlaceholder: String = "Type the theme here or pick one ⬇️."
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
                    
                    ThemePickerView(themeChoices: $textGeneration.setTheme)
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
                    
                    GenrePickerView(genreChoices: $textGeneration.setGenre)
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
                if !isInputActive {
                    Section {
                        HStack {
                            Spacer()
                            
                            Button {
                               // TODO: need to make sure this is added once, maybe use boolean
                                let text = textGeneration.promptDesign(theme, textGeneration.primary.text)
                                textGeneration.getTextResponse(moderated: false, sessionStory: text)
                                showingStoryEditorScreen.toggle()
//                                UserDefaults.standard.setValue(true, forKey: "hadLaunched")
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                            }
                            .buttonStyle(SendButton())
                            
//                            NavigationLink(destination: StoryEditorView(), isActive: $showingStoryEditorScreen) { }
                        }
                    }
                }
            }
            // next screen of adding a book review is shown when showingAddScreen is true
            .fullScreenCover(isPresented: $showingStoryEditorScreen) {
                StoryEditorView()
            }
            .alert(title, isPresented: $alertUser, presenting: message) {_ in
                Button("OK") {}
            }
            .transition(.opacity)
            .navigationTitle("Prompt Editor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isInputActive {
                        Button {
                            let text = textGeneration.promptDesign(theme, textGeneration.primary.text)
                            textGeneration.getTextResponse(moderated: false, sessionStory: text)
                            showingStoryEditorScreen.toggle()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                        }
                        .buttonStyle(SendButton())
                        .padding()
                    } else {
                        Button("Cancel") {
                            dismissEditPrompt()
                        }
                        .buttonStyle(.plain)
                    }
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
}
