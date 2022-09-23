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
   
    @State private var isShowingAccountScreen = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingPromptEditorScreen = false
    @State private var isShowingSearchScreen = false
    
    @FocusState private var isInputActive: Bool
    
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
                                Image(systemName: "arrow.up.circle.fill")
                            }
                            .buttonStyle(SendButton())
                            .padding()
                        } else {
                            NavigationLink(destination: StoryEditorView()) {
                                Label("New Story", systemImage: "square.and.pencil")
                            }
                            
                            Menu {
                                Button { // this belongs with create a story view
                                    isShowingPromptEditorScreen.toggle()
                                } label: {
                                    Label("Prompt Editor", systemImage: "doc.badge.gearshape")
                                }
                                
                                Button {
                                    isShowingLoginScreen.toggle()
                                } label: {
                                    Label("Login", systemImage: "lanyardcard")
                                }
                                
                                Button {
                //                        showingImagePicker.toggle()
                                } label: {
                                    Text("Images")
                                    Image(systemName: "arrow.up.and.down.circle")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                           }
                        }
                    }
                    
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
                .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
                .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
                .sheet(isPresented: $isShowingAccountScreen) { AccountView() }
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
