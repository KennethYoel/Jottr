//
//  SearchView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/15/22.
//

import SwiftUI

struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: GenTextViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    
    let workOfFiction = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink(destination: Text(name)) {
                        Text(name)
                    }
                }
            }
            .searchable(text: $searchQuery, placement:  .navigationBarDrawer(displayMode: .always), prompt: "Seek It") {
                //provide tappable suggestions as the user types
                ForEach(searchResults, id: \.self) { result in
//                    Label(suggestion.title,  image: suggestion.image)
//                                    .searchCompletion(suggestion.text)
                    Text("Are you looking for \(result)?").searchCompletion(result)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismissSearch()
                        dismiss()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    var searchResults: [String] {
        if searchQuery.isEmpty {
            return workOfFiction // [textGeneration.primary.text]
        } else {
            /*
             localizedCaseInsensitiveContains()
             lets us check any part of the search strings, without worrying about
             uppercase or lowercase letters [textGeneration.primary.text]
             */
            return workOfFiction.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}
