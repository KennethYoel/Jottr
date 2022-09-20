//
//  ThemePicker.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/19/22.
//

import SwiftUI

enum CommonTheme { //: String, CaseIterable, Identifiable 
    // Six common themes in literature are:
    case  goodVsEvil, love, redemption, courageAndPerseverance, comingOfAge, revenge
    
    var stringComparisons: String {
        switch self {
        case .goodVsEvil:
            return "Good vs. Evil"
        case .love:
            return "Love"
        case .redemption:
            return "Redemption"
        case .courageAndPerseverance:
            return "Courage and Perseverance"
        case .comingOfAge:
            return "Coming of Age"
        case .revenge:
            return "Revenge"
        }
    }
}

struct ThemePicker: View {
    // MARK: Properties
    
    @Binding var themeChoices: CommonTheme?
    @State private var showingThemeOptions = false
    
    var body: some View {
        Button(themeChoices?.stringComparisons ?? "Common Themes") {
            showingThemeOptions = true
        }
        .actionSheet(isPresented: $showingThemeOptions) {
            ActionSheet(title: Text("Choose a common theme for the prompt"),
                buttons: [
                    .default(Text(CommonTheme.goodVsEvil.stringComparisons)) {
                        themeChoices = .goodVsEvil
                    },
                    .default(Text(CommonTheme.love.stringComparisons)) {
                        themeChoices = .love
                    },
                    .default(Text(CommonTheme.redemption.stringComparisons)) {
                        themeChoices = .redemption
                    },
                    .default(Text(CommonTheme.courageAndPerseverance.stringComparisons)) {
                        themeChoices = .courageAndPerseverance
                    },
                    .default(Text(CommonTheme.comingOfAge.stringComparisons)) {
                        themeChoices = .comingOfAge
                    },
                    .default(Text(CommonTheme.revenge.stringComparisons)) {
                        themeChoices = .revenge
                    },
                    .cancel()
                ]
            )
        }
        .buttonStyle(.borderedProminent)
        
//        Picker("Themes", selection: $themeChoices) {
//            ForEach(CommonTheme.allCases) {
//                Text($0.rawValue).tag($0)
//            }
//        }
//        if let finalChoice = themeChoices?.rawValue {
//            Text("Selected theme: \(finalChoice)")
//        }
    }
}
