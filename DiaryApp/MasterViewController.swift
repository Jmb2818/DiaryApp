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
    
    @IBOutlet weak var entryTableView: UITableView!
    
    private let dateEditor = DateEditor()
    var entries: [NSManagedObject] = []
    var coreDataStack = CoreDataStack()
    
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
        let formattedDate = dateEditor.monthDayYearFrom(todaysDate)
        self.navigationItem.title = formattedDate
    }
    
    func presentDetailView(with entry: Entry, at indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        let model = EntryModel(entry: entry)
        controller.model = model
        controller.entry = entry
        controller.coreDataStack = coreDataStack
        show(controller, sender: nil)
    }
    
    func configureInitialModel() {
        guard dataSource.entriesCount == 0 || !dataSource.entryEnteredToday() else {
            return
        }
        let todaysDate = Date()
        let formattedDate = dateEditor.weekdayDayMonthFrom(todaysDate) ?? ""
        let initialModel = EntryModel(date: formattedDate, entry: "Record your thoughts for today", mood: "")
        Entry.with(initialModel, in: coreDataStack.managedObjectContext)
        coreDataStack.managedObjectContext.saveChanges()
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = dataSource.entryAt(indexPath)
        presentDetailView(with: entry, at: indexPath)
    }
}
