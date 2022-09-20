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
    
    @EnvironmentObject var textGeneration: TextGeneration
    @Environment(\.dismiss) var dismiss
    
    @State private var setTheme: CommonTheme? = nil
    @State var showingAccountScreen = false
    
    @Binding var currentView: LoadingState
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        ScrollView {
            TextEditor(text: $textGeneration.sessionStory)
                .focused($isInputActive)
                .padding([.leading, .trailing])
            
            Button("Con't") {
                textGeneration.getTextResponse(moderated: false, sessionStory: textGeneration.sessionStory)
            }
            .buttonStyle(.bordered)
            .cornerRadius(40)
            .foregroundColor(.black)
            .padding(10)
            
            Button("Dismiss") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .cornerRadius(40)
            .foregroundColor(.black)
            .padding(10)
        }
        .transition(.opacity)
//        .navigationTitle("Story Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    showingAccountScreen.toggle()
//                } label: {
//                    Label("Account", systemImage: "wallet.pass")
//                }
//                .buttonStyle(.plain)
//            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()

                ThemePicker(themeChoices: $setTheme)
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
        .sheet(isPresented: $showingAccountScreen) {
            AccountView()
        }
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
