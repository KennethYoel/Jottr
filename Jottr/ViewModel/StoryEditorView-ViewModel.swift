//
//  StoryEditorView-ViewModel.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/6/22.
//

import Foundation

extension StoryEditorView {
    @MainActor class ViewModel: ObservableObject {
        @Published var setTheme: CommonTheme = .custom
        @Published var theme: String = ""
        @Published var storyTitle: String = ""
    }
}
