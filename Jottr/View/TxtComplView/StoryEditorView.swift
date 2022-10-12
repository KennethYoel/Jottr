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
    
//    @Binding var isButtonDisable: Bool
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    @Environment(\.undoManager) var undoManager
    @Environment(\.dismiss) var dismissStoryEditor
    
    @FocusState private var isInputActive: Bool
    
    @StateObject private var viewModel = ViewModel()
    @State private var storyEditorPlaceholder: String = "Perhap's we can begin with once upon a time..."
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
//    @State private var isNewStoryEditorScreen = false
    @State private var stories = [SessionStory]()
    
    var body: some View {
        TextEditorView(title: $txtComplVM.title, text: $txtComplVM.primary.text, placeholder: storyEditorPlaceholder)
                .focused($isInputActive)
                .padding([.leading, .top, .trailing,])
                .overlay(loadingOverlay)
                .sheet(isPresented: $isShowingPromptEditorScreen, onDismiss: {
                    Task {
                        await generateStory(themeOfStory: viewModel.theme)
                    }
                }, content: {
                    PromptEditorView(theme: $viewModel.theme)
                })
                // the sheet below is shown when isShareViewPresented is true
                .sheet(isPresented: $isShareViewPresented, onDismiss: {
                    debugPrint("Dismiss")
                }, content: {
                    ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
                })
                .alert(isPresented: $txtComplVM.failed) {
                    Alert(title: Text(""),
                          message: Text("\(txtComplVM.errorMessage)"),
                          primaryButton: .default(
                            Text("Try Again"),
                            action: {
                                Task {
                                    await txtComplVM.getTextResponse(moderated: false, sessionStory: txtComplVM.primary.text)
                                }
                            }
                          ),
                          secondaryButton: .cancel(
                            Text("Cancel"),
                            action: {
                                txtComplVM.failed.toggle()
                            }
                          )
                    )
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        if let undoManager = undoManager {
                            Button(action: undoManager.undo) {
                                Label("Undo", systemImage: "arrow.uturn.backward")
                            }
                            .disabled(!undoManager.canUndo)

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
                            ThemePickerView(themeChoices: $viewModel.setTheme)
                                .padding()
                            
                            Button {
                                Task {
                                    await txtComplVM.getTextResponse(moderated: false, sessionStory: txtComplVM.primary.text)
                                }
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
                        if !isInputActive {
                            Spacer()
                            
                            ThemePickerView(themeChoices: $viewModel.setTheme)
                                .padding()
                        }
                    }
                }.disabled(txtComplVM.loading) // when loading users can't interact with this view.
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        if txtComplVM.loading {
            Color(white: 0, opacity: 0.05)
            GIFView()
                .frame(width: 295, height: 155)
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
    }
    
    func generateStory(themeOfStory: String) async {
        // TODO: need to make sure this is added once, maybe use boolean
        let text = txtComplVM.promptDesign(themeOfStory, txtComplVM.primary.text)
        await txtComplVM.getTextResponse(moderated: false, sessionStory: text)
    }
    
    private func save() {
        //add a story
        let newStory = Story(context: moc)
        newStory.id = UUID()
        newStory.creationDate = Date()
        newStory.genre = txtComplVM.setGenre.id
        newStory.title = txtComplVM.title
        newStory.sessionPrompt = txtComplVM.promptLoader
        newStory.complStory = txtComplVM.primary.text
        
        if txtComplVM.setTheme.id == "Custom" {
            newStory.theme = viewModel.theme
        } else {
            newStory.theme = txtComplVM.setTheme.id
        }
        
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                // Show some error here
                debugPrint("\(error.localizedDescription)")
            }
        }
        
//        PersistenceController.shared.saveContext()
        
        txtComplVM.title = ""
        txtComplVM.primary.text = ""
        
        dismissStoryEditor()
    }
}
