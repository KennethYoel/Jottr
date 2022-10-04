//
//  CompTextDetailView-ViewModel.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/4/22.
//

import Foundation

extension ListDetailView {
    @MainActor class ViewModel: ObservableObject {
        @Published var title = ""
        @Published var sessionStory = ""
    }
}
