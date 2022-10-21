//
//  NoteBookView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/12/22.
//

import Foundation
import SwiftUI

struct NoteBookView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @State private var isShowingStoryEditorScreen: Bool = false
    @State private var isShowingLoginScreen: Bool = false
    @State private var isShowingSearchScreen: Bool = false
    @State private var isShowingStoryListView: Bool = false
    @State private var isShowingAccountScreen: Bool = false
    @State private var isShowingSettingsScreen: Bool = false
    @State private var isStoryListActive: Bool = false
    @State private var isHidden: Bool = false
    
    var body: some View {
        List {
            Section {
                // a link to a list of stories
                NavigationLink(isActive: $isStoryListActive) {
                    ContentView(currentView: .storyList(false))
                } label: {
                    Label("Collection", systemImage: "archivebox")
                        .font(.custom("Futura", size: 13))
                }
                .buttonStyle(.plain)
                
                // a link to a list of stories written in the past seven days
                NavigationLink {
                    ContentView(currentView: .storyList(true))
                } label: {
                    Label("Recent", systemImage: "deskclock")
                        .font(.custom("Futura", size: 13))
                }
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
        .fullScreenCover(isPresented: $isShowingAccountScreen) { AccountView() }
        .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
        .overlay(MagnifyingGlass(showSearchScreen: $isShowingSearchScreen), alignment: .bottomTrailing)
        .navigationTitle("🖋Jottr") //highlighter
        .toolbar { noteBookTopToolbar }
    }
    
    // MARK: External Properties
    // the property will be inline very nicely by the swift optimizer also when the body is re-computed, changed program state for example, swift will recall the properties as needed
    var noteBookTopToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: showStoryEditor, label: {
                Label("New Story", systemImage: "square.and.pencil")
            })
                .padding()
                .buttonStyle(.plain)
            
            Button(action: showAccountScreen, label: {
                Label("Account", systemImage: "ellipsis.circle")
            })
                .padding(.trailing)
                .buttonStyle(.plain)
            
//            Menu {
//                Button(action: showLoginScreen, label: {
//                    Label("Login", systemImage: "lanyardcard")
//                })
//
//                Button(action: showAccountScreen, label: {
//                    Label("Account", systemImage: "pencil.and.outline")
//                })
//
//                Button("Settings", action: showSettingsScreen)
//            } label: {
//                 Image(systemName: "gearshape.2")
//            }
        }
    }
    
    private func showStoryEditor() {
        isShowingStoryEditorScreen.toggle()
    }
    
    private func showAccountScreen() {
        isShowingAccountScreen.toggle()
    }
}

struct NoteBookView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}

