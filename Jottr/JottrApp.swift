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
    @State private var hadLaunched = UserDefaults.standard.bool(forKey: "hadLaunched")
    
    var body: some Scene {
        WindowGroup {
            MainView(hadLaunched: $hadLaunched)
                .environmentObject(textGeneration)
        }
    }
}
