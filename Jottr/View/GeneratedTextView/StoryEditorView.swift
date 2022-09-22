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
    
    @State private var progress = 0.2
    @State private var setTheme: CommonTheme? = nil
    @State var showingAccountScreen = false
    
//    @Binding var currentView: LoadingState
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        Form {
//            ProgressView(value: progress, total: 1.0)
//                .progressViewStyle(GaugeProgressStyle())
//                .frame(width: 200, height: 200)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    if progress < 1.0 {
//                        withAnimation {
//                            progress += 0.2
//                        }
//                    }
//                    textGeneration.sessionPrompt[0].text
//                }
            TextEditor(text: $textGeneration.sessionStory)
                .focused($isInputActive)
                .padding([.leading, .trailing])
//                .frame(maxHeight: .infinity)
            
//            Button("Dismiss") {
//                dismiss()
//            }
//            .buttonStyle(.bordered)
//            .cornerRadius(40)
//            .foregroundColor(.black)
//            .padding(10)
        }
        .sheet(isPresented: $showingAccountScreen) {
            AccountView()
        }
        .transition(.opacity)
//        .navigationTitle("Story Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if isInputActive {
                    ThemePicker(themeChoices: $setTheme)
                        .padding()
                    
                    Button("Write It") {
                        textGeneration.getTextResponse(moderated: false, sessionStory: textGeneration.sessionStory)
                    }
                    .buttonStyle(CustomButton())
                    .padding()
                } else {
                    Button {
                        showingAccountScreen.toggle()
                    } label: {
                        Label("Account", systemImage: "square.and.pencil")
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        showingAccountScreen.toggle()
                    } label: {
                        Label("Account", systemImage: "ellipsis.circle")
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
            }
            
//            ToolbarItemGroup(placement: .bottomBar) {
//                Spacer()
//
//                ThemePicker(themeChoices: $setTheme)
//                    .padding()
//            }
            
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
