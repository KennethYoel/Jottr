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
    
    // a property to store the persistence data controller
    @StateObject private var persistenceController = PersistenceController()
    
    // create text generator object
    @StateObject var txtComplVM = TxtComplViewModel()
    // @AppStorage stores user defaults similarly as using userDefaults.standard
    @AppStorage("hadLauncehd") private var hadLaunched = false //UserDefaults.standard.bool(forKey: "hadLaunched")
    // when the app moves to the background, we call the save() method so that Core Data saves your changes permanently
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView(hadLaunched: $hadLaunched)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(txtComplVM)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
