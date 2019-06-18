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
    private let context: NSManagedObjectContext
    
    var entriesCount: Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    init(fetchRequest: NSFetchRequest<Entry>, managedObjectContext context: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        self.fetchedResultsController = EntriesFetchedResultsController(request: fetchRequest, context: context)
        self.context = context
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
        cell.configureWith(model, isEdited: entry.isEdited)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let entry = fetchedResultsController.object(at: indexPath)
            context.delete(entry)
        default:
            break
        }
    }
    
    func entryAt(_ indexPath: IndexPath) -> Entry {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func entryEnteredToday() -> Bool {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return false
        }
        
        let todaysDate = DateEditor.weekdayDayMonthFrom(Date())
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
