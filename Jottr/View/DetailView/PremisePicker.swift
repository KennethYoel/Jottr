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
