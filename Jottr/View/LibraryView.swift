//
//  LibraryView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/9/22.
//

import SwiftUI

struct LibraryView: View {
    // MARK: Properties
    
    // have form dismiss itself
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textGeneration: TextGenerationStore
//    @State private var showingLoginScreen = false
    @State private var isHidden: Bool = false
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        Form {
            Section {
                // a link to a list of stories
                NavigationLink {
                    StoryCollectionsView()
                } label: {
                    Label("Your Narratives", systemImage: "archivebox")
                        .font(.system(.body, design: .serif))
                }
                .buttonStyle(.plain)
                
                // a link to a list of premises written by the user
                NavigationLink {
                    StoryCollectionsView()
                } label: {
                    Label("Your Premises", systemImage: "highlighter")
                        .font(.system(.body, design: .serif))
                }
                .buttonStyle(.plain)
                
                // a link to a list stories the user deleted
                HStack {
                    Image(systemName: "trash")
                    Text("Trash")
                        .font(.system(.body, design: .serif))
                }
            }
            
            Section {
                if !isHidden {
                    TextEditor(text: $review)
                    /*
                     custom ui component-the result is much nicer to use: there’s no need
                     to tap into a detail view with a picker here, because star ratings are
                     more natural and more common.
                     */
    //                RatingView(rating: $rating)
    //                    Picker("Rating", selection: $rating) {
    //                        ForEach(0..<6) {
    //                            Text(String($0))
    //                        }
    //                    }
                }
            } header: {
                HStack {
                    Text("INTRODUCTION")
                        .font(.system(.caption, design: .serif))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding([.top, .bottom], 5)
                    Spacer()
                    Text("...")
                        .font(.system(.caption, design: .serif))
                        .contextMenu {
                            if !isHidden {
                                Button {
                                    isHidden.toggle()
                                } label: {
                                    Label("Expand", systemImage: "rectangle.expand.vertical")
                                }
                            } else {
                                Button {
                                    isHidden.toggle()
                                } label: {
                                    Label("Collapse", systemImage: "rectangle.compress.vertical")
                                }
                            }
                        }
                }
            }
            
//            Section {
//                Button("Save") {
                    // add the book
//                    let newBook = Book(context: moc)
//                    newBook.id = UUID()
//                    newBook.title = title
//                    newBook.author = author
//                    newBook.rating = Int16(rating)
//                    newBook.genre = genre
//                    newBook.review = review
//                    
//                    try? moc.save()
//                    dismiss()
//                }
//            }
        } // MARK: Form Modyfiers
    }
}
