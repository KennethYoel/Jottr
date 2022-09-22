//
//  ItemsToolbar.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/22/22.
//

import SwiftUI

struct ItemsToolbar: ToolbarContent {
    
    @Binding var showingPromptEditorScreen: Bool
    @Binding var showingLoginScreen: Bool
    @Binding var showingSearchScreen: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            NavigationLink(destination: StoryEditorView()) {
                Label("New Story", systemImage: "square.and.pencil")
            }
            
            Menu {
                Button { // this belongs with create a story view
                    showingPromptEditorScreen.toggle()
                } label: {
                    Label("Prompt Editor", systemImage: "doc.badge.gearshape")
                }
                
                Button {
                    showingLoginScreen.toggle()
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
                 Image(systemName: "gearshape.2")
            }
        }
    }
}
