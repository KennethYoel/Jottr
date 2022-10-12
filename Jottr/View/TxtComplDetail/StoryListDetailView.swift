//
// StoryListDetailView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/28/22.
//

import CoreData
import SwiftUI

struct StoryListDetailView: View {
    // MARK: Properties
    
    let story: Story
    // create an object that manages the data(the logic) of ListDetailView layout
    @StateObject private var viewModel = ViewModel()
    // holds our openai text completion model
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete stuff)
    @Environment(\.managedObjectContext) var moc
    // holds our dismiss action (so we can pop the view off the navigation stack)
    @Environment(\.dismiss) var dismissDetailView
    // holds our undoManager
    @Environment(\.undoManager) var undoManager
    // holds boolean value on whether the txt input field is active
    @FocusState private var isInputActive: Bool
   
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    @State private var isShareViewPresented: Bool = false
    // control whether we’re showing the delete confirmation alert or not
    @State private var showingDeleteAlert = false
    
    var body: some View {
        TextEditorView(title: $viewModel.title, text: $viewModel.sessionStory, placeholder: "")
            .onAppear {
                self.viewModel.title = story.wrappedTitle
                self.viewModel.sessionStory = story.wrappedComplStory
            }
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
                        dismissDetailView()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isInputActive {
                        Button {
                            save()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill") //chevron.compact.down
                        }
                        .task {
                            await txtComplVM.getTextResponse(moderated: false, sessionStory: viewModel.sessionStory)
                        }
                        .buttonStyle(SendButton())
                        .padding()
                    }
                }
                // newStoryEditorScreen: $isNewStoryEditorScreen.onChange(save),
                EditorToolbar(showingShareView: $isShareViewPresented, showingPromptEditorScreen: $isShowingPromptEditorScreen, showingKeyboard: _isInputActive)
            } // the sheet below is shown when isShareViewPresented is true
            .sheet(isPresented: $isShareViewPresented, onDismiss: {
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
            })
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
        isInputActive = false
        save()
    }
    
    private func save() {
        //update the saved story
        moc.performAndWait {
            story.title = self.viewModel.title
            story.complStory = self.viewModel.sessionStory
            
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    // Show some error here
                    debugPrint("\(error.localizedDescription)")
                }
            }
            
//            PersistenceController.shared.saveContext()
        }
        // cant update this view :(
        self.viewModel.sessionStory = txtComplVM.primary.text
        
//        dismissDetailView()
    }
    
    func deleteBook() {
        // delete from in memory storage
        moc.delete(story)
        
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                // Show some error here
                debugPrint("\(error.localizedDescription)")
            }
        }
        
        // write the changes out to persistent storage
//        PersistenceController.shared.saveContext()
        
        // hide current view
        dismissDetailView()
    }
}

//struct GenTextDetailView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//        let story = Story(context: moc)
//        story.id = UUID()
//        story.creationDate = Date()
//        story.sessionPrompt = "Test Prompt"
//        story.title = "Test Title"
//        story.sessionStory = "Test Story"
//        story.theme = "Redemption"
//        story.genre = "Horror"
//
//        return NavigationView {
//            GenTextDetailView(story: story)
//        }
//    }
//}
