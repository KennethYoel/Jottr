//
//  ThemePicker.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/19/22.
//

import SwiftUI

enum CommonTheme: String, CaseIterable, Identifiable {
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

struct ThemePickerView: View {
    // MARK: Properties
    
    @Binding var themeChoices: CommonTheme?
    @State private var showingThemeOptions = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Choose a theme >_")
                .font(.custom("Futura", size: 17))
            
            Picker("Theme", selection: $themeChoices) {
                ForEach(CommonTheme.allCases) {
                    Text($0.id).tag($0)
                        .font(.custom("Futura", size: 17))
                }
            }
            .pickerStyle(.menu)
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView(themeChoices: .constant(.goodVsEvil))
    }
}
