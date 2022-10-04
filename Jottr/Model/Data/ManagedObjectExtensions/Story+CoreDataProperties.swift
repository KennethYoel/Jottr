//
//  Jottr+CoreDataProperties.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/3/22.
//

import CoreData
import Foundation

extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var creationDate: Date?
    @NSManaged public var genre: String?
    @NSManaged public var theme: String?
    @NSManaged public var title: String?
    @NSManaged public var sessionPrompt: String?
    @NSManaged public var sessionStory: String?
    
    /*
     adding computed properties that help us access the optional values safely, while also letting us store your nil coalescing
     code all in one place. For example, adding this as a property on Movie ensures that we always have a valid title string to
     work with-This way the whole rest of your code doesn’t have to worry about Core Data’s optionality, and if you want to
     make changes to default values you can do it in a single file.
     */
    public var wrappedGenre: String {
        genre ?? "fantasy"
    }
    public var wrappedTheme: String {
        theme ?? "custom"
    }
    public var wrappedTitle: String {
        title ?? "Unkown Title"
    }
    public var wrappedSessionPrompt: String {
        sessionPrompt ?? "Unkown Prompt"
    }
    public var wrappedSessionStory: String {
        sessionStory ?? "Unkown Story"
    }

}

extension Story : Identifiable {
    
}
