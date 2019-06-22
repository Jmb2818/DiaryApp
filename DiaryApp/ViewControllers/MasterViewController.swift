//
//  MasterViewController.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/5/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController {
    
    @IBOutlet weak var addEntryButton: UIBarButtonItem!
    @IBOutlet weak var entryTableView: UITableView!
    
    var entries: [NSManagedObject] = []
    var coreDataStack = CoreDataStack()
    private var initialModel: EntryModel {
        let todaysDate = Date()
        let formattedDate = DateEditor.weekdayDayMonthFrom(todaysDate) ?? ""
        return EntryModel(date: formattedDate, entry: "Record your thoughts for today", mood: "")
    }
    
    lazy var dataSource: EntryTableViewDataSource = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        return EntryTableViewDataSource(fetchRequest: request, managedObjectContext: self.coreDataStack.managedObjectContext, tableView: self.entryTableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTableView.dataSource = dataSource
        configureInitialModel()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryTableView.reloadData()
    }
    
    func setUpNavigationBar() {
        let todaysDate = Date()
        let formattedDate = DateEditor.monthDayYearFrom(todaysDate)
        self.navigationItem.title = formattedDate
    }
    
    func presentDetailView(with entry: Entry?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        if let entry = entry {
            let model = EntryModel(entry: entry)
            controller.model = model
            controller.entry = entry
        } else {
            controller.model = initialModel
        }
        
        controller.coreDataStack = coreDataStack
        show(controller, sender: nil)
    }
    
    func configureInitialModel() {
        guard dataSource.entriesCount == 0 else {
            return
        }

        Entry.with(initialModel, in: coreDataStack.managedObjectContext)
        coreDataStack.managedObjectContext.saveChanges()
    }
    
    @IBAction func addNewEntry(sender: UIBarButtonItem) {
        let firstEntry = dataSource.entryAt(IndexPath(row: 0, section: 0))
        if !firstEntry.isEdited {
            presentDetailView(with: firstEntry)
        } else {
            presentDetailView(with: nil)
        }
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = dataSource.entryAt(indexPath)
        presentDetailView(with: entry)
    }
}
