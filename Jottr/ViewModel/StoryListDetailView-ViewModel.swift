//
//  StoryListtDetailView-ViewModel.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/4/22.
//

import Foundation

extension StoryListDetailView {
    @MainActor class StoryListDetailVM: ObservableObject {
        @Published var isShowingStoryEditorScreen: Bool = false
        @Published var isShowingPromptEditorScreen: Bool = false
        @Published var isShowingEditorToolbar: Bool = false
        @Published var isShareViewPresented: Bool = false
        // control whether we’re showing the delete confirmation alert or not
        @Published var showingDeleteAlert = false
    }
    
    // MARK: Helper Methods
    
    func hideKeyboardAndSave() {
        isInputActive = false
        updateContext()
    }
    
    func sendToStoryCreator() {
        Task {
            await txtComplVM.generateStory()
        }
        updateContext()
    }
    
    func launchNewPage() {
        updateContext()
        txtComplVM.sessionStory = ""
        dismissDetailView()
        viewModel.isShowingStoryEditorScreen.toggle()
    }
    
    func exportToFile() {
        
    }
    
    func storyToShare() -> String {
        let sheet = """
        \(txtComplVM.sessionStory)
        """
        return sheet
    }
    
    func presentShareView() {
        viewModel.isShareViewPresented.toggle()
    }
    
    func updateContext() {
        //update the saved story
        moc.performAndWait {
            story.complStory = self.txtComplVM.sessionStory
            
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
