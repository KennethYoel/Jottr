//
//  ItemsToolbar.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/22/22.
//

import Foundation
import SwiftUI

struct LibraryToolbar: ToolbarContent {
    
    @Binding var showingPromptEditorScreen: Bool
    @Binding var showingLoginScreen: Bool
    @Binding var showingFeedbackScreen: Bool
    @Binding var showingSettingsScreen: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            NavigationLink(destination: StoryEditorView()) {
                Label("New Story", systemImage: "square.and.pencil")
            }
            
            Menu {
                Button {
                    showingLoginScreen.toggle()
                } label: {
                    Label("Login", systemImage: "lanyardcard")
                }
                
                Button {
                    showingFeedbackScreen.toggle()
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
