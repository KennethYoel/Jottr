//
//  DataController.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/19/22.
//

import CoreData
import Foundation

class PersistenceController: ObservableObject {
    // storage for Core Data
    let container: NSPersistentContainer
    
    // a test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: false)
        
        // create a example story
        let story = Story(context: controller.container.viewContext)
        story.id = UUID()
        story.genre = "Horror"
        story.theme = "Redemption"
        story.sessionPrompt = "Test Prompt"
        story.complStory = "Test Story"
        
        return controller
    }()
    
    // an initializer to load CoreData, optionally able to use an in-memory store
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Jottr")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        /*
         This asks Core Data to merge duplicate objects based on their properties – it tries to intelligently overwrite the
         version in its database using properties from the new version. If you run the code again you’ll see something quite
         brilliant: you can press Add as many times as you want, but when you press Save it will all collapse down into a
         single row because Core Data strips out the duplicates.
         */
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                debugPrint("\(error.localizedDescription)")
            }
        }
    }
}
