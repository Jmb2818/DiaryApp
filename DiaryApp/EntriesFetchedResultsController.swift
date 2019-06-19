//
//  EntriesFetchedResultsController.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/26/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import CoreData

class EntriesFetchedResultsController: NSFetchedResultsController<Entry> {
    init(request: NSFetchRequest<Entry>, context: NSManagedObjectContext) {
        super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "month", cacheName: nil)
        
        fetch()
    }
    
    func fetch() {
        do {
            try performFetch()
        } catch {
            fatalError()
        }
    }
}
