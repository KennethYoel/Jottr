//
//  StoryListRowView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation
import SwiftUI

struct StoryListRowView: View {
    let story: Story
    // anything with content closure we rip out that chunk of code and create a seperate view as we did here.
    var body: some View {
        NavigationLink {
            ContentView(currentView: .storyListDetail(story)) //StoryListDetailView(story: story)
        } label: {
            VStack(alignment: .leading) {
                Text(story.wrappedComplStory)
                    .foregroundColor(.secondary)
                    .font(.system(.subheadline, design: .serif))
                    // limit the amount of text shown in each item in the list
                    .lineLimit(3)
                
                HStack {
                    Label("Char(s)", systemImage: "text.alignleft")
                    Text(story.formattedDate)
                        .font(.system(.caption, design: .serif))
                }
            }
        }
    }
}
