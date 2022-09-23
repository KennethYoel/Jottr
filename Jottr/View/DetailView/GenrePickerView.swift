//
//  GenrePickerView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/23/22.
//

import SwiftUI

enum CommonGenre: String, CaseIterable, Identifiable {
    // the seven common genre in literature:
    case  fantasy, scienceFiction, horror, childrenFiction, mystery, romance, thriller
    
    var id: String {
        switch self {
        case .fantasy:
            return "Fantasy"
        case .scienceFiction:
            return "Science Fiction"
        case .horror:
            return "Horror"
        case .childrenFiction:
            return "Children's Fiction"
        case .mystery:
            return "Mystery"
        case .romance:
            return "Romance"
        case .thriller:
            return "Thriller"
        }
    }
}

struct GenrePickerView: View {
    // MARK: Properties
    
    @Binding var genreChoices: CommonGenre?
    @State private var showingGenreOptions = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Choose a genre >_")
                .font(.custom("Futura", size: 17))
            
            Picker("Genre", selection: $genreChoices) {
                ForEach(CommonGenre.allCases) {
                    Text($0.id).tag($0)
                        .font(.custom("Futura", size: 17))
                }
            }
            .pickerStyle(.menu)
        }
    }
}

struct GenrePickerView_Previews: PreviewProvider {
    static var previews: some View {
        GenrePickerView(genreChoices: .constant(.fantasy))
    }
}
