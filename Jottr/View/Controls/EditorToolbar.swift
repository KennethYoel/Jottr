//
//  EditorToolbar.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/27/22.
//

import Foundation
import SwiftUI

struct EditorToolbar: ToolbarContent {
    
    @Binding var showingShareView: Bool
    @Binding var showingPromptEditorScreen: Bool
    @FocusState var showingKeyboard: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if !showingKeyboard {
                NavigationLink(destination: StoryEditorView()) {
                    Label("New Story", systemImage: "square.and.pencil")
                }
                
                Menu {
                    Button {
                        showingShareView.toggle()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                            showingPromptEditorScreen.toggle()
                    } label: {
                        Text("Prompt Settings")
                        Image(systemName: "doc.badge.gearshape")
                    }
                } label: {
                     Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}
