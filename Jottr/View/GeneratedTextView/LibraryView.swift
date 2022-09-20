//
//  LibraryView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/9/22.
//

import SwiftUI

struct HideSectionView: View {
    // MARK: Properties
    
    @Binding var isHidden: Bool
    
    var body: some View {
        Menu("...") {
            if !isHidden {
                Button {
                    isHidden.toggle()
                } label: {
                    Label("Collapse", systemImage: "rectangle.compress.vertical")
                }
            } else {
                Button {
                    isHidden.toggle()
                } label: {
                    Label("Expand", systemImage: "rectangle.expand.vertical")
                }
            }
        }
        .font(.system(.caption, design: .serif))
    }
}

struct LibraryView: View {
    // MARK: Properties
    
    // have form dismiss itself
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textGeneration: TextGeneration
    
//    @State private var showingLoginScreen = false
    @State private var isHidden: Bool = false
    @State private var isShowingStoryListView = false
    @State private var genre = ""
    @State private var review = ""
    
    @Binding var currentView: LoadingState
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        Form {
            Section {
                // a link to a list of stories
                Button {
                    self.currentView = .storyList
//                    StoryCollectionsView()
                } label: {
                    Label("Your Narratives", systemImage: "archivebox")
                        .font(.system(.body, design: .serif))
                }
                .buttonStyle(.plain)
                
                // a link to a list of premises written by the user
                NavigationLink {
                    StoryListView(currentView: $currentView)
                } label: {
                    Label("as of ", systemImage: "deskclock")
                        .font(.system(.body, design: .serif))
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories the user recently deleted
                Button {
                    self.currentView = .storyList
//                    StoryListView()
                } label: {
                    Label("Trash", systemImage: "trash")
                        .font(.system(.body, design: .serif))
                }
                .buttonStyle(.plain)
            }
            
            Section {
                if !isHidden {
                    image
                        .resizable()
                        .scaledToFit()
                }
                
                Button("Save Image") {
                    guard let inputImage = inputImage else { return }
                    
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: inputImage)
                }
            } header: {
                HStack {
                    Text("INTRODUCTION")
                        .font(.system(.caption, design: .serif))
    //                        .frame(maxWidth: .infinity, alignment: .leading)
    //                        .padding([.top, .bottom], 5)
                    
                    Spacer()
                    
                    HideSectionView(isHidden: $isHidden)
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
        .transition(.opacity)
        .navigationTitle("🖋Jottr") //highlighter
    }
}
