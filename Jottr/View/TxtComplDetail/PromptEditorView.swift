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
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismissPromptEdit
    //    @Binding var hadLaunched: Bool
    
    @FocusState private var isInputActive: Bool
    
//    @StateObject var loginVM = LoginViewModel()

    @State private var explainerContent: Explainer = .themeExplainer
    @State private var isShowingThemePopover: Bool = false
    @State private var isShowingPremisePopover: Bool = false
    @State private var isShowingBannedPopover: Bool = false
    
    @State private var alertUser: Bool = false
    @State private var message: String = ""
    
    @Binding var theme: String // = ""
    @State private var showingStoryEditorScreen = false
    
    let themePlaceholder: String = "Type the theme here or pick one ⬇️."
    let premisePlaceholder: String = "Type the premise here..."
    let textLimit = 350
//    let detector = PassthroughSubject<Void, Never>()
//    let publisher: AnyPublisher<Void, Never>
    
//    init() {
//        publisher = detector
//            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
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
                    
                    ThemePickerView(themeChoices: $txtComplVM.setTheme)
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
                    TextEditorView(title: $txtComplVM.title, text: $txtComplVM.primary.text, placeholder: premisePlaceholder)
                        .focused($isInputActive)
                        .foregroundColor(.primary)
                        .font(.custom("Futura", size: 15))
                        .onReceive(Just(txtComplVM.primary.text)) { _ in limitText(textLimit) }
//                        .onChange(of: txtComplVM.primary.text) { _ in detector.send() }
//                        .onReceive(publisher) { save() }
                    
                    GenrePickerView(genreChoices: $txtComplVM.setGenre)
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
//                if !isInputActive {
//                    Section {
//                        HStack {
//                            Spacer()
//
//                            Button {
                               // TODO: need to make sure this is added once, maybe use boolean
//                                dismissPromptEdit()
//                                let text = textGeneration.promptDesign(theme, textGeneration.primary.text)
//                                textGeneration.getTextResponse(moderated: false, sessionStory: text)
//                                showingStoryEditorScreen.toggle()
//                                UserDefaults.standard.setValue(true, forKey: "hadLaunched")
//                            } label: {
//                                Image(systemName: "arrow.up.circle.fill")
//                            }
//                            .buttonStyle(SendButton())
//                        }
//                    }
//                }
            }
//            .alert(title, isPresented: $alertUser, presenting: message) {_ in
//                Button("OK") {}
//            }
            .transition(.opacity)
            .navigationTitle("Prompt Editor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismissPromptEdit()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .buttonStyle(SendButton())
                    .padding()
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
        if theme.count & txtComplVM.primary.text.count > upper {
            theme = String(theme.prefix(upper))
            txtComplVM.sessionPrompt[0].text = String(txtComplVM.primary.text.prefix(upper))
        }
    }
}
