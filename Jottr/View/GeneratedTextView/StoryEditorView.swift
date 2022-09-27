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
    
    @EnvironmentObject var textGeneration: GenTextViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isInputActive: Bool
    
    @State private var progress = 0.2
    @State private var setTheme: CommonTheme = .custom
   
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingPromptEditorScreen: Bool = false
    @State private var isShowingEditorToolbar: Bool = false
    
    var body: some View {
//        ProgressView(value: progress, total: 1.0)
//            .progressViewStyle(GaugeProgressStyle())
//            .frame(width: 200, height: 200)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if progress < 1.0 {
//                    withAnimation {
//                        progress += 0.2
//                    }
//                }
//                textGeneration.sessionPrompt[0].text
//            }
        TextEditor(text: $textGeneration.sessionStory)
            .focused($isInputActive)
            .padding([.leading, .top, .trailing,])
            .transition(.opacity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isInputActive {
                        ThemePickerView(themeChoices: $setTheme)
                            .padding()
                        
                        Button {
                            textGeneration.getTextResponse(moderated: false, sessionStory: textGeneration.sessionStory)
                        } label: {
                            Image(systemName: "arrow.up.circle.fill") //chevron.compact.down
                        }
                        .buttonStyle(SendButton())
                        .padding()
                    }
                }
                
                EditorToolbar(showingShareView: $isShareViewPresented, showingPromptEditorScreen: $isShowingPromptEditorScreen, showingKeyboard: _isInputActive)
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()

                    ThemePickerView(themeChoices: $setTheme)
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
            .sheet(isPresented: $isShowingPromptEditorScreen) { PromptEditorView() }
            // the sheet below is shown when isShareViewPresented is true
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
        //add a story
//        let newBook = Book(context: moc)
//        newBook.id = UUID()
//        newBook.title = title
//        newBook.author = author
//        newBook.rating = Int16(rating)
//        newBook.genre = genre
//        newBook.review = review
//
//        try? moc.save()
//        dismiss()
   }
}
