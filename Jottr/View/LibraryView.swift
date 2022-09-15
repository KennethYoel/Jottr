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
    @EnvironmentObject var textGeneration: TextGenerationStore
//    @State private var showingLoginScreen = false
    @State var isHidden: Bool = false
    @State private var genre = ""
    @State private var review = ""
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    
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
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
                Button {
                    print("Search")
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .symbolRenderingMode(.multicolor)
                        .padding(.trailing)
                }
                .accessibilityLabel("Show help")
        }
    }
}
