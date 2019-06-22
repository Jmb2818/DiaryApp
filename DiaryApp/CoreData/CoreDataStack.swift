//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation
import CoreData

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
    func saveChanges() {
        do {
            try save()
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
}
