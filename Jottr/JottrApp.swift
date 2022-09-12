//
//  JottrApp.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import SwiftUI

@main
struct JottrApp: App {
    // MARK: Properties

    @StateObject var textGeneration = TextGenerationStore()
    @State var hadLaunched = UserDefaults.standard.bool(forKey: "hadLaunched")
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // initial view
                NavigationView {
                    ContentView() //, hadLaunched: $hadLaunched
                }
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                }
                // the web of story elements view
//                NavigationView {
//                    StoryCorpusView() //hadLaunched: $hadLaunched
//                }
//                .tabItem {
//                    Label("Layout", systemImage: "newspaper.circle.fill")
//                }
            }
            .environmentObject(textGeneration)
        }
    }
}
