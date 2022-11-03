//
//  SearchView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/15/22.
//

import SwiftUI

struct SearchView: View {
    // MARK: Properties
    
    @EnvironmentObject var txtComplVM: TxtComplViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.creationDate)]) var workOfFiction: FetchedResults<Story>
    @State private var searchQuery: String = ""
    @State private var searching: Bool = false
   
    var body: some View {
        NavigationView {
            /*
             This isn’t going to use @FetchRequest because we want to be able to create a
             custom fetch request inside an initializer. some predicate to use: ==, < >, IN,
             CONTAINS[c], BEGINSWITH, ... sortedBy: [],
             */
//            FilteredList(sortKey: "creationDate", orderByAscending: false, isSearching: $searching, filterKey: "complStory", filterBy: .containsCaseInsensitive(searchQuery), filterValue: searchQuery) { (recentStory: Story) in
//                NavigationLink(destination: Text(recentStory.wrappedComplStory)) {
//                    Text(recentStory.wrappedComplStory)
//                        .foregroundColor(.secondary)
//                        .font(.system(.subheadline, design: .serif))
//                        // limit the amount of text shown in each item in the list
//                        .lineLimit(3)
//                }
//            }
            List {
                ForEach(searchResults, id: \.self) { eachStory in
                    NavigationLink(destination: Text(eachStory)) {
                        Text(eachStory)
                    }
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Seek It") {
                //provide tappable suggestions as the user types
                ForEach(searchResults, id: \.self) { result in
//                    Label(suggestion.title,  image: suggestion.image).searchCompletion(suggestion.text)
                    Text("Are you looking for \(result)?").searchCompletion(result)
                }
//                FilteredList(sortKey: "creationDate", orderByAscending: false, isSearching: $searching, filterKey: "complStory", filterBy: .containsCaseInsensitive(searchQuery), filterValue: searchQuery) { (recentStory: Story) in
//                    Text(recentStory.wrappedComplStory).searchCompletion(recentStory.wrappedComplStory)
//                }
            }
            .navigationTitle("Recently Modified")
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
        var stories: [String] = []
        
        if searchQuery.isEmpty {
            for tale in workOfFiction {
                if let unwrappedStory = tale.complStory {
                    stories += [unwrappedStory]
                }
            }
            
            return stories
        } else {
            /*
             localizedCaseInsensitiveContains()
             lets us check any part of the search strings, without worrying about
             uppercase or lowercase letters [textGeneration.primary.text]
             */
            workOfFiction.nsPredicate = NSPredicate(format: "%K IN %@", "complStory", "\(searchQuery)")
            for tale in workOfFiction {
                if let unwrappedStory = tale.complStory {
                    stories += [unwrappedStory]
                }
            }
            
            return stories
        }
    }
}


/*
 
 import SwiftUI

     @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)]) var workOfFiction: FetchedResults<Story>
     var highlightedText = [AttributedString("")]
    
     var body: some View {
         NavigationView {
             List(searchResults, id: \.self) { item in
 //                Text("Recently Modified")
 //                    .font(.system(.title, design: .serif))
 //                    .textSelection(.enabled)
 //                    .listRowSeparator(.hidden)
                 
                 NavigationLink(destination: Text(item)) {
                     Text(item)
                         .foregroundColor(.secondary)
                         .font(.system(.subheadline, design: .serif))
                         // limit the amount of text shown in each item in the list
                         .lineLimit(3)
                         .textSelection(.enabled)
                 }
                 
 //                ForEach(searchResults, id: \.self) { eachStory in
 //                    NavigationLink(destination: Text(eachStory)) {
 //                        Text(eachStory)
 //                            .foregroundColor(.secondary)
 //                            .font(.system(.subheadline, design: .serif))
 //                            // limit the amount of text shown in each item in the list
 //                            .lineLimit(3)
 //                            .textSelection(.enabled)
 //                    }
 //                }
             }
             .navigationTitle("Recently Modified")
             .navigationBarTitleDisplayMode(.inline)
             .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search") {
                 Text("\(searchResults.count) Items")
                 
 //                Text(searchResults)
 //                    .font(.system(.title2, design: .serif))
 //                    .textSelection(.enabled)
                 
                 //provide tappable suggestions as the user types
                 ForEach(searchResults, id: \.self) { result in
                     Text(result)
                         .searchCompletion(result)
                         .font(.system(.body, design: .serif))
                         .textSelection(.enabled)
                 }
             }
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
 //        .onChange(of: searchQuery) { _ in highlightText() }
     }
     
     var searchResults: [String] {
         get {
             var stories: [String] = [""]
             
             if searchQuery.isEmpty {
                 for tale in workOfFiction {
                     if let unwrappedStory = tale.complStory {
                         stories += [unwrappedStory]
                     }
                 }
                 return stories
             } else {
                 /*
                  localizedCaseInsensitiveContains()
                  lets us check any part of the search strings, without worrying about
                  uppercase or lowercase letters
                  */
                 for tale in workOfFiction {
                     if let unwrappedStory = tale.complStory {
                         stories += [unwrappedStory]
                     }
                 }
                 // may need to put the code back to what it was and convert it after in highlightText()
                 return stories.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
             }
         }
     }
     
     var highlightedResults: [AttributedString] {
         get {
             var attributedResults: [AttributedString] = [AttributedString()]
             var attributedItems: AttributedString!
             
             for item in searchResults {
                 attributedItems = AttributedString(item)
                 if let range = attributedItems.range(of: searchQuery) {
                    attributedItems[range].backgroundColor = .blue
                    attributedItems[range].foregroundColor = .white
                 }
                 attributedResults += [attributedItems]
             }
             return attributedResults
         }
    }
 }

 */
