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
    
    // when the app moves to the background, we call the save() method so that Core Data saves your changes permanently
    @Environment(\.scenePhase) var scenePhase
    // create an instance of NetworkMonitor then inject it into the SwiftUI environment
    let monitor = NetworkMonitor()
    // a property to store the persistence data controller
    @StateObject private var persistenceController = PersistenceController()
    // create an instance of TxtComplViewModel then inject it into the SwiftUI environment
    @StateObject var txtComplVM = TxtComplViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(monitor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(txtComplVM)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
