//
//  EntryTableViewDataSource.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/28/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewDataSource: NSObject, UITableViewDataSource {
    private let tableView: UITableView
    private let fetchedResultsController: EntriesFetchedResultsController
    private let dateEditor = DateEditor()
    
    var entriesCount: Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    init(fetchRequest: NSFetchRequest<Entry>, managedObjectContext context: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        self.fetchedResultsController = EntriesFetchedResultsController(request: fetchRequest, context: context)
        super.init()
        
        self.fetchedResultsController.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError()
        }
        
        let entry = fetchedResultsController.object(at: indexPath)
        let model = EntryModel(entry: entry)
        cell.configureWith(model)
        return cell
    }
    
    func entryAt(_ indexPath: IndexPath) -> Entry {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func entryEnteredToday() -> Bool {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return false
        }
        
        let todaysDate = dateEditor.weekdayDayMonthFrom(Date())
        if entries.contains(where: {
            $0.date == todaysDate
        }) {
            return true
        }
        
        return false
    }
}

extension EntryTableViewDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
