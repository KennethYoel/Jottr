//
//  SearchView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/15/22.
//

import SwiftUI

struct SearchView: View {
    // MARK: Properties
    
    let workOfFiction = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchDocs = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink(destination: Text(name)) {
                        Text(name)
                    }
                }
            }
            .searchable(text: $searchDocs, prompt: "Own Your Truth")
            .navigationTitle("All")
//            .navigationViewStyle(.inline)
        }
    }
    
    var searchResults: [String] {
            if searchDocs.isEmpty {
                return workOfFiction
            } else {
                return workOfFiction.filter { $0.contains(searchDocs) }
            }
        }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
