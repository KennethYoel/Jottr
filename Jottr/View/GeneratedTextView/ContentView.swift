//
//  ContentView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import SwiftUI

enum LoadingState {
    case library, storyList, storyEditor //(Binding<Bool>)
}

struct ContentView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: GenTextViewModel
    var currentView = LoadingState.library
    
    // MARK: View
    
    var body: some View {
        switch currentView {
        case .library:
            LibraryView()
        case .storyList:
            StoryListView()
        case .storyEditor:
            StoryEditorView()
        }   
    }
}

/*
 @Binding,it allows us to create a two-way connection between PushButton and
 whatever is using it, so that when one value changes the other does too. Lets us
 store a mutable value in a view that actually points to some other value from
 elsewhere. In the case of Toggle, the switch changes its own local binding to a
 Boolean, but behind the scenes that’s actually manipulating the @State property
 of rememberMe in our view.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
                .environmentObject(GenTextViewModel())
        }
        .previewInterfaceOrientation(.portrait)
    }
}
