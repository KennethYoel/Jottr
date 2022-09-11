//
//  LibraryView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/9/22.
//

import SwiftUI

struct LibraryView: View {
    // MARK: Properties
    
    @EnvironmentObject var generationModel: TextGenerationModel
    @State private var showingStoryCorpusScreen = false
    
    var body: some View {
        VStack {
            List {
                /*
                 We don’t need to provide an identifier for the ForEach because all
                 Core Data’s managed object class conform to Identifiable
                 automatically, but things are trickier when it comes to creating
                 views inside the ForEach.
                 */
                ForEach(generationModel.sessionPrompt) { story in
                    /*
                     All the properties of our Core Data entity are optional, which
                     means we need to make heavy use of nil coalescing in order to
                     make our code work.
                     */
                    NavigationLink {
                        StoryTellerView()
//                        Text(book.title ?? "Unknown Title")
                    } label: {
                        HStack {
//                                EmojiRatingView(rating: book.rating)
//                                    .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(story.text)
                                    .font(.headline)
                                
//                                    Text(book.author ?? "Unknown Author")
//                                        .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                // swipe to delete
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("🖋Jottr")
            .toolbar {
                // Edit/Done button for deleting and other perform such as seen above
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingStoryCorpusScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                        Button {
                            let _ = 1
                        } label: {
                            Text("Radial")
                            Image(systemName: "arrow.up.and.down.circle")
                        }
                    } label: {
                         Text("Style")
                         Image(systemName: "tag.circle")
                    }
                    
//                    Button {
//                        showingStoryCorpusScreen.toggle()
//                    } label: {
//                        Label("Add Book", systemImage: "plus")
//                    }
                }
            } // next screen of adding a book review is shown when showingAddScreen is true
            .fullScreenCover(isPresented: $showingStoryCorpusScreen) { StoryCorpusView() }
            //.sheet
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
//        for offset in offsets {
//            let book = books[offset]
//            // delete from in memory storage
//            moc.delete(book)
//        }
//        // write the changes out to persistent storage
//        do {
//            try moc.save()
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
