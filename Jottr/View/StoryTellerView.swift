//
//  StoryTellerView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/6/22.
//

import SwiftUI
import Foundation

struct StoryTellerView: View {
    // MARK: Properties
    
    @StateObject var generationModel: TextGenerationModel
    @State var showingAccountScreen = false
    
    var body: some View {
        ScrollView {
            Text(generationModel.story)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Button("Con't") {
                generationModel.getTextResponse(moderated: false, sessionStory: generationModel.story)
            }
            .buttonStyle(.bordered)
            .cornerRadius(40)
            .foregroundColor(.white)
            .padding(10)
            
//            Form {
//                Label("A Tall Story to Tell:", systemImage: "quote.bubble")
                    .font(.headline)
    //                .bold()
    //                .multilineTextAlignment(.center)
                
//                Section { // the error is responseCompletion is null
//                    Text(viewModel.primary.text)
//                        .padding(.horizontal)
//                }
                
//                Section {
//                    TextEditor(text: $completedText) //$textForPrompt
                    /*
                     custom ui component-the result is much nicer to use: there’s no need
                     to tap into a detail view with a picker here, because star ratings
                     are more natural and more common.
                     completion.choices[0].completionText
                     */
    //                    RatingView(rating: $rating)
    //                    Picker("Rating", selection: $rating) {
    //                        ForEach(0..<6) {
    //                            Text(String($0))
    //                        }
    //                    }
//                } header: {
//                    Text("Write A Story")
//                }
                // change a text into a nav link example
    //            NavigationLink(destination: StoryBodyView()) {
    //                Text(completion.choices[0].completionText)
    //                    // adaptive padding
    //                    .padding(.top)
    //                    // enables the slightly grey text to adapt to the background color of the screen
    //                    .foregroundColor(.secondary)
    //                    .task {
                            // adds an asynchronous task to perform when this view appears
        //                    await fetchReadings()
    //                    }
    //            }
//            }
            .navigationTitle("🖋Jottr")
            .toolbar {
                // Edit/Done button for deleting and other perform such as seen above
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // save the text in TextEditor and then refresh the TextEditor.
                    } label: {
                        Label("Restart", systemImage: "plus")
                    }
    //                EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAccountScreen.toggle()
                    } label: {
                        Label("Account", systemImage: "wallet.pass")
                    }
                }
            }
            .onTapGesture { hideKeyboardAndSave() }
            .sheet(isPresented: $showingAccountScreen) {
                AccountView()
            }
        }
    }
    
    // MARK: Helper Methods
    
    private func hideKeyboardAndSave() {
       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//       save()
   }
    
//   private func save() {
//       textForPrompt = completedText
//       completedText = completions.textForPrompt//textForPrompt
//   }
}
