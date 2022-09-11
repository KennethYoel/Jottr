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

    @StateObject var generationModel = TextGenerationModel()
    @State var hadLaunched = UserDefaults.standard.bool(forKey: "hadLaunched")
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // initial view
                NavigationView {
                    ContentView() //, hadLaunched: $hadLaunched
                }
//                .tabItem {
//                    Label("Play", systemImage: "play.circle.fill")
//                    Image(systemName: "play.circle.fill")
//                    Text("Play")
//                }
                // the web of story elements view
//                NavigationView {
//                    StoryCorpusView() //hadLaunched: $hadLaunched
//                }
//                .tabItem {
//                    Label("Layout", systemImage: "newspaper.circle.fill")
//                }
            }
            .environmentObject(generationModel)
        }
    }
}
