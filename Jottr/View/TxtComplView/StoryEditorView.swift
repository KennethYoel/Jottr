//
//  StoryTellerView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/6/22.
//

import Foundation
import SwiftUI

struct StoryEditorView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.undoManager) var undoManager
    @Environment(\.dismiss) var dismissStoryEditor
    
    @FocusState private var isInputActive: Bool
    
    @State private var setTheme: CommonTheme = .custom
    
    @State private var theme: String = ""
    @State private var storyTitle: String = ""
    
    @State private var storyEditorPlaceholder: String = "Perhap's we can begin with once upon a time..."
   
//    @State private var isNewStoryEditorScreen = false
    @State private var progress = 0.2
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    @State private var showingAlert = false
    
    @State private var stories = [SessionStory]()
    
    var body: some View {
        switch txtComplVM.loadingAPIState {
        case .loading:
            ProgressView("Downloading…") // only works in this editor, not in promptEditor
//            ProgressView(value: progress, total: 1.0)
//                .progressViewStyle(GaugeProgressStyle())
//                .frame(width: 50, height: 50)
//                .contentShape(Rectangle())
//                .onAppear {
//                    if progress < 10.0 {
//                        withAnimation {
//                            progress += 0.2
//                        }
//                    }
//                }
        case .loaded:
            TextEditorView(title: $txtComplVM.title, text: $txtComplVM.primary.text, placeholder: storyEditorPlaceholder)
                    .focused($isInputActive)
                    .padding([.leading, .top, .trailing,])
                    .transition(.opacity)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            if let undoManager = undoManager {
                                Button(action: undoManager.undo) {
                                    Label("Undo", systemImage: "arrow.uturn.backward")
                                }
                                .disabled(!undoManager.canUndo)
                                
                                Spacer()

                                Button(action: undoManager.redo) {
                                    Label("Redo", systemImage: "arrow.uturn.forward")
                                }
                                .disabled(!undoManager.canRedo)
                            }
                            
                            Spacer()
                            
                            Button {
                                hideKeyboardAndSave()
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Done", role: .destructive) {
                                save()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            if isInputActive {
                                ThemePickerView(themeChoices: $setTheme)
                                    .padding()
                                
                                Button {
                                    txtComplVM.getTextResponse(moderated: false, sessionStory: txtComplVM.primary.text)
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill") //chevron.compact.down
                                }
                                .buttonStyle(SendButton())
                                .padding()
                            }
                        }
                        // newStoryEditorScreen: $isNewStoryEditorScreen.onChange(save),
                        EditorToolbar(showingShareView: $isShareViewPresented, showingPromptEditorScreen: $isShowingPromptEditorScreen, showingKeyboard: _isInputActive)
                        
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()

                            ThemePickerView(themeChoices: $setTheme)
                                .padding()
                        }
                    }
                    .sheet(isPresented: $isShowingPromptEditorScreen, onDismiss: {
                        generateStory(themeOfStory: theme)
                    }, content: {
                        PromptEditorView(theme: $theme)
                    })
                    // the sheet below is shown when isShareViewPresented is true
                    .sheet(isPresented: $isShareViewPresented, onDismiss: {
                        debugPrint("Dismiss")
                    }, content: {
                        ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
                    })
        case .failed(let error):
            EmptyView()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Unable to Write a Story"),
                          message: Text("\(error.localizedDescription)"),
                          primaryButton: .default(
                            Text("Try Again"),
                            action: {
                                txtComplVM.getTextResponse(moderated: false, sessionStory: txtComplVM.primary.text)
                            }
                          ),
                          secondaryButton: .cancel(
                            Text("Cancel")
                          )
                    )
                }
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
    }
    
    func generateStory(themeOfStory: String) {
        // TODO: need to make sure this is added once, maybe use boolean
        let text = txtComplVM.promptDesign(themeOfStory, txtComplVM.primary.text)
        txtComplVM.getTextResponse(moderated: false, sessionStory: text)
    }
    
    private func save() {
        //add a story
        let newStory = Story(context: moc)
        newStory.id = UUID()
        newStory.creationDate = Date()
        newStory.genre = txtComplVM.setGenre.id
        newStory.title = txtComplVM.title
        newStory.sessionPrompt = txtComplVM.sessionPrompt
        newStory.sessionStory = txtComplVM.primary.text
        
        if txtComplVM.setTheme.id == "Custom" {
            newStory.theme = theme
        } else {
            newStory.theme = txtComplVM.setTheme.id
        }
        
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        dismissStoryEditor()
    }
}
