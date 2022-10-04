//
//  EditorToolbar.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/27/22.
//

import Foundation
import SwiftUI

struct EditorToolbar: ToolbarContent {
    
//    @Binding var newStoryEditorScreen: Bool
    @Binding var showingShareView: Bool
    @Binding var showingPromptEditorScreen: Bool
    @FocusState var showingKeyboard: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if !showingKeyboard {
//                Button {
//                    newStoryEditorScreen.toggle()
//                } label: {
//                    Label("New Story", systemImage: "square.and.pencil")
//                }
                
                Menu {
                    Button {
                        showingPromptEditorScreen.toggle()
                    } label: {
                        Label("Export", systemImage: "arrow.up.doc")
                    }
                    
                    Button {
                        showingShareView.toggle()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        showingPromptEditorScreen.toggle()
                    } label: {
                        Label("Prompt Editor", systemImage: "doc.badge.gearshape")
                    }
                } label: {
                     Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}
