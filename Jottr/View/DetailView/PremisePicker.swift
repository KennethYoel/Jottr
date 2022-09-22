//
//  PremisePickerView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/20/22.
//

import SwiftUI

enum PremiseSample { //: String, CaseIterable, Identifiable
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

struct PremisePicker: View {
    // MARK: Properties
    
    @Binding var themeChoices: CommonTheme?
    @State private var showingThemeOptions = false
    
    var body: some View {
        Button {
            showingThemeOptions = true
        } label: {
            Label(themeChoices?.stringComparisons ?? "Choose a Theme", systemImage: "theatermasks")
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
        .buttonStyle(.plain)
    }
}

struct PremisePicker_Previews: PreviewProvider {
    static var previews: some View {
        PremisePicker(themeChoices: .constant(.goodVsEvil))
    }
}

/*
 The world of literature abounds with different genres. Broadly speaking, the fiction world is divided
 into two segments: literary fiction and genre fiction. Literary fiction typically describes the kinds
 of books that are assigned in high school and college English classes, that are character driven and
 describe some aspect of the human condition. Pulitzer Prize and National Book Award winners tend to
 come from the literary fiction genre. Genre fiction has a more mainstream, populist appeal. It
 traditionally comprises genres such as romance, mystery, thriller, horror, fantasy, and children’s
 books.

 Some genre writers straddle a line between genre-focused commercial fiction and the traditions of
 literary fiction. John Updike, for instance, has been noted for his somewhat pulpy novels that still
 managed to examine humanity. J.R.R. Tolkien developed a worldwide following within the fantasy genre,
 yet his Lord of the Rings trilogy is famous for its intricate themes.
 */
