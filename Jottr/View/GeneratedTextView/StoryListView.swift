//
//  StoryCollectionsView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/12/22.
//

import SwiftUI

struct StoryListView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGeneration
    @State private var isShareViewPresented: Bool = false
    
    @State private var isShowingAccountScreen = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingPromptEditorScreen = false
    @State private var isShowingSearchScreen = false
    
    // defines a date formatter and uses it to make sure a task date is presented in human-readable form:
    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    let dueDate = Date()
    
    var body: some View {
        VStack {
            List {
                /*
                 We don’t need to provide an identifier for the ForEach because all
                 Core Data’s managed object class conform to Identifiable
                 automatically, but things are trickier when it comes to creating
                 views inside the ForEach.
                 */
                ForEach(textGeneration.sessionPrompt) { story in
                    /*
                     All the properties of our Core Data entity are optional, which
                     means we need to make heavy use of nil coalescing in order to
                     make our code work.
                     */
                    NavigationLink {
                        StoryEditorView() //currentView: $currentView.animation(.easeInOut)
//                        Text(book.title ?? "Unknown Title")
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Title of the Story") // story.title
                                .font(.system(.headline, design: .serif))
                            
                            Text(story.text) //?? "Unknown Story"
                                .foregroundColor(.secondary)
                                .font(.system(.subheadline, design: .serif))
                                // limit the amount of text shown in each item in the list
                                .lineLimit(3)
                            
                            HStack {
                                Label("Char(s)", systemImage: "text.alignleft")
                                Text("\(dueDate, formatter: Self.taskDateFormat)") // Date of Creation
                                    .font(.system(.caption, design: .serif))
                            }
                        }
                    }
                } // swipe to delete
                .onDelete(perform: deleteStory)
            }  // the sheet below is shown when isShareViewPresented is true
            .sheet(isPresented: $isShareViewPresented, onDismiss: {
                debugPrint("Dismiss")
            }, content: {
                ActivityViewController(itemsToShare: ["The Story"]) //[URL(string: "https://www.swifttom.com")!]
            })
            //.fullScreenCover
        } // Complete Works -> Opera Omnia
        .transition(.opacity)
        .navigationTitle("Collection")
        .toolbar {
            ItemsToolbar(showingPromptEditorScreen: $isShowingPromptEditorScreen, showingLoginScreen: $isShowingLoginScreen, showingSearchScreen: $isShowingSearchScreen)
        }
        .sheet(isPresented: $isShowingPromptEditorScreen) { PromptEditorView() }
        .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
        .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
    }
    
    func deleteStory(at offsets: IndexSet) {
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
