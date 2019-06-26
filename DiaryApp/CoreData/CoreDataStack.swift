//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation
import CoreData

/// Class for managing all of the main Core Data objects
class CoreDataStack {
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
}

extension NSManagedObjectContext {
    /// Function to save the changes made to the core data entities
    func saveChanges() {
        do {
            try save()
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
}
