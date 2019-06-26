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
        let monthSort = NSSortDescriptor(key: "sectionDate", ascending: false)
        let creationSort = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [monthSort, creationSort]
        return request
    }
    
    @NSManaged public var creationDate: Date
    @NSManaged public var image: NSData
    @NSManaged public var date: String
    @NSManaged public var entry: String
    @NSManaged public var mood: String
    @NSManaged public var isEdited: Bool
    @NSManaged public var creationLocation: String?
    @NSManaged public var sectionDate: Date?
    @NSManaged public var editedDate: String?
}

extension Entry {
    static var entityName: String {
        return String(describing: Entry.self)
    }
    
    @nonobjc class func with(_ entryModel: EntryModel, in context: NSManagedObjectContext, isEdited: Bool = false) {
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as? Entry else {
            return
        }
        
        let todaysDate = Date()
        entry.creationDate = todaysDate
        entry.sectionDate = DateEditor.startOfMonthFrom(todaysDate)
        entry.date = entryModel.date
        entry.entry = entryModel.entry
        entry.mood = entryModel.mood
        entry.isEdited = isEdited
        
        if let creationLocation = entryModel.creationLocation {
            entry.creationLocation = creationLocation
        }
    }
}

extension Entry {
    var entryImage: UIImage? {
        guard let image = UIImage(data: self.image as Data) else {
            return nil
        }
        return image
    }
}

enum EntryKeys: String {
    case creationDate
    case image
    case date
    case entry
    case mood
    case isEdited
    case creationLocation
    case sectionDate
    case editedDate
}
