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
    
    // create text generator object
    @StateObject var textGeneration = GenTextViewModel()
    // @AppStorage stores user defaults similarly as using userDefaults.standard
    @AppStorage("hadLauncehd") private var hadLaunched = false //UserDefaults.standard.bool(forKey: "hadLaunched")
    
    var body: some Scene {
        WindowGroup {
            MainView(hadLaunched: $hadLaunched)
                .environmentObject(textGeneration)
        }
    }
}
