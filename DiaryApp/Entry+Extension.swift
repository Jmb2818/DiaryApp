//
//  Entry+Extension.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit
import CoreData

class Entry: NSManagedObject {}

extension Entry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var creationDate: Date
    @NSManaged public var date: String
    @NSManaged public var entry: String
    @NSManaged public var mood: String
    @NSManaged public var isEdited: Bool
    @NSManaged public var creationLocation: String
}

extension Entry {
    static var entityName: String {
        return String(describing: Entry.self)
    }
    
    @nonobjc class func with(_ entryModel: EntryModel, in context: NSManagedObjectContext) {
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as? Entry else {
            return
        }
        
        entry.creationDate = Date()
        entry.date = entryModel.date
        entry.entry = entryModel.entry
        entry.mood = entryModel.mood
        entry.isEdited = false    }
}
