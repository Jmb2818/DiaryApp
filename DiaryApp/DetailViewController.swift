//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/12/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var editLocationButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var averageButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    
    lazy var moodButtonArray = [goodButton, averageButton, badButton]
    var model: EntryModel?
    var coreDataStack: CoreDataStack?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEntry))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
        navigationItem.setLeftBarButton(backButton, animated: false)
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func setupView() {
        guard let model = model else {
            return
        }
        locationLabel.isHidden = true
        editLocationButton.isHidden = true
        self.entryDateLabel.text = model.date
        self.entryTextView.text = model.entry
    }
    
    @objc func cancelEntry() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func saveEntry() {
        guard let coreDataStack = coreDataStack else {
            return
        }
        var selectedMood = ""
        moodButtonArray.forEach({
            if $0?.isSelected ?? false {
                selectedMood = $0?.restorationIdentifier ?? ""
            }
        })
        let model = EntryModel(date: entryDateLabel.text ?? "", entry: entryTextView.text ?? "", mood: selectedMood)
        Entry.with(model, in: coreDataStack.managedObjectContext)
        coreDataStack.managedObjectContext.saveChanges()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func resetMoodButtons() {
        moodButtonArray.forEach { button in
            button?.layer.borderWidth = 0
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.isSelected = false
        }
    }
    
    @IBAction func moodSelected(sender: UIButton) {
        guard !sender.isSelected else {
            resetMoodButtons()
            return
        }
        resetMoodButtons()
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.white.cgColor
        sender.isSelected = true
    }
}
