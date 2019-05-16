//
//  MasterViewController.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/5/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var entryTableView: UITableView!
    
    private let dateEditor = DateEditor()
    var models: [EntryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func presentDetailView() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        show(controller, sender: nil)
    }
    
    func configureInitialModel() {
        let todaysDate = Date()
        let formattedDate = dateEditor.weekdayDayMonthFrom(todaysDate) ?? ""
        let initialModel = EntryModel(date: formattedDate, entry: "Record your thoughts for today", mood: "")
        models.append(initialModel)
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailView()
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            fatalError()
        }
        
        let model = models[indexPath.row]
        cell.configureWith(model)
        return cell
    }
    
    
}
