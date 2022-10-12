//
//  NoteBookView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/12/22.
//

import SwiftUI

struct NoteBookView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @State private var isShowingStoryEditorScreen: Bool = false
    @State private var isShowingLoginScreen: Bool = false
    @State private var isShowingFeedbackScreen: Bool = false
    @State private var isShowingSearchScreen: Bool = false
    @State private var isShowingStoryListView: Bool = false
    @State private var isShowingSettingsScreen: Bool = false
    @State private var isStoryListActive: Bool = false
    @State private var isHidden: Bool = false
    
    var body: some View {
        Form {
            Section {
                // a link to a list of stories
                NavigationLink(isActive: $isStoryListActive) {
                    ContentView(currentView: .storyList)
                } label: {
                    Label("Your Narratives", systemImage: "archivebox")
                        .font(.custom("Futura", size: 13))
                }
                .isDetailLink(false)
                .buttonStyle(.plain)
                
                // a link to a list of stories written the past seven days
                NavigationLink {
                    ContentView(currentView: .storyList)
                } label: {
                    Label("Recent", systemImage: "deskclock")
                        .font(.custom("Futura", size: 13))
                }// "as of \(currentDate - 604800, formatter: Self.taskDateFormat)"
                .buttonStyle(.plain)
                
                // a link to a list of stories the user recently deleted
                NavigationLink {
//                    self.currentView = .storyList
//                    StoryListView()
                } label: {
                    Label("Trash", systemImage: "trash")
                        .font(.custom("Futura", size: 13))
                }
                .buttonStyle(.plain)
            }
            
            Section {
                if !isHidden {
                    Text("Intro")
                }
            } header: {
                HStack {
                    Text("INTRODUCTION")
                        .font(.system(.caption, design: .serif))
                    
                    Spacer()
                    
                    HideSectionView(isHidden: $isHidden)
                }
            }
        } // MARK: Form Modyfiers
        .fullScreenCover(isPresented: $isShowingStoryEditorScreen, onDismiss: {
            isStoryListActive.toggle()
        }, content: {
            NavigationView {
                StoryEditorView()
            }
        })
        .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
        .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
        .navigationTitle("🖋Jottr") //highlighter
        .toolbar { noteBookToolbar }
        .magnifyingGlass(show: $isShowingSearchScreen) // add a magnifying glass to view
    }
    
    var noteBookToolbar: some ToolbarContent {
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
}

struct NoteBookView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}

