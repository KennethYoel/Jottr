//
//  PremisePickerView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/20/22.
//

import SwiftUI

enum PremiseExamples: String, CaseIterable, Identifiable {
    // Six common themes in literature are:
    case  goodVsEvil, love, redemption, courageAndPerseverance, comingOfAge, revenge
    
    var id: String {
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

struct PremisePickerView: View {
    // MARK: Properties
    
    @Binding var premiseChoices: CommonTheme?
    @State private var showingThemeOptions = false
    
    var body: some View {
        Picker("Premise", selection: $premiseChoices) {
            ForEach(PremiseExamples.allCases) {
                Text($0.id).tag($0)
                    .font(.custom("Futura", size: 17))
            }
        }
        .pickerStyle(.menu)
    }
}

struct PremisePicker_Previews: PreviewProvider {
    static var previews: some View {
        PremisePickerView(premiseChoices: .constant(.goodVsEvil))
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
