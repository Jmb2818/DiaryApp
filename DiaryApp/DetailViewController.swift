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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEntry))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
        navigationItem.setLeftBarButton(backButton, animated: false)
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        locationLabel.isHidden = true
        editLocationButton.isHidden = true
    }
    
    @objc func cancelEntry() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func saveEntry() {
        let rootViewController = navigationController?.viewControllers.filter({ $0 is MasterViewController })
        if let rootController = rootViewController?.first as? MasterViewController {
            var selectedMood = ""
            moodButtonArray.forEach({
                if $0?.isSelected ?? false {
                    selectedMood = $0?.restorationIdentifier ?? ""
                }
            })
            let model = EntryModel(date: entryDateLabel.text ?? "", entry: entryTextView.text ?? "", mood: selectedMood)
            rootController.models.append(model)
        }
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
