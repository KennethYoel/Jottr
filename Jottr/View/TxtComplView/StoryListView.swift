//
//  StoryCollectionsView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/12/22.
//

import SwiftUI

struct StoryListView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    // holds our Core Data managed object context (so we can delete or save stuff)
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stories: FetchedResults<Story>
    
    @State private var isShareViewPresented: Bool = false
    @State private var isShowingLoginScreen: Bool = false
    @State private var isShowingStoryEditorScreen: Bool = false
    @State private var isShowingFeedbackScreen: Bool = false
    @State private var isShowingSettingsScreen: Bool = false
    @State private var isShowingSearchScreen: Bool = false
    @State private var isActive: Bool = false
    var isRecentList: Bool = false
    
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
                ForEach(stories) { story in
                    NavigationLink {
                        StoryListDetailView(story: story)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(story.wrappedTitle)
                                .font(.system(.headline, design: .serif))
                            
                            Text(story.wrappedComplStory)
                                .foregroundColor(.secondary)
                                .font(.system(.subheadline, design: .serif))
                                // limit the amount of text shown in each item in the list
                                .lineLimit(3)
                            
                            HStack {
                                Label("Char(s)", systemImage: "text.alignleft")
                                Text(String(describing: story.creationDate!)) // dueDate, formatter: Self.taskDateFormat
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
        } // Complete Works -> Opera Omnia
        .fullScreenCover(isPresented: $isShowingStoryEditorScreen, content: {
            NavigationView {
                StoryEditorView()
            }
        })
        .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
        .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
        .navigationTitle("Collection")
        .toolbar { storyListToolbar }
        .magnifyingGlass(show: $isShowingSearchScreen)
    }
    
//    var listOfStories: FetchedResults<Story> {
//        if !isRecentList {
//            // manned to do a fetch search to return the last seven day.
//            return stories[0].creationDate
//        } else {
//            return stories
//        }
//    }
    
    var storyListToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                isShowingStoryEditorScreen.toggle()
            } label: {
                Label("New Story", systemImage: "square.and.pencil")
            }
            
            Menu {
                Button {
                    isShowingLoginScreen.toggle()
                } label: {
                    Label("Login", systemImage: "lanyardcard")
                }
                
                Button {
                    isShowingFeedbackScreen.toggle()
                } label: {
                    Label("Feedback", systemImage: "pencil.and.outline")
                }
                
                Button {
    //                        showingImagePicker.toggle()
                } label: {
                    Text("Settings")
                    Image(systemName: "slider.horizontal.3")
                }
            } label: {
                 Image(systemName: "gearshape.2")
            }
        }
    }
    
    func deleteStory(at offsets: IndexSet) {
        for offset in offsets {
            let story = stories[offset]
            // delete from in memory storage
            moc.delete(story)
        }
        // write the changes out to persistent storage
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
