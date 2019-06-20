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
    @IBOutlet weak var entryImageView: UIImageView!
    
    lazy var moodButtonArray = [goodButton, averageButton, badButton]
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    var model: EntryModel?
    var coreDataStack: CoreDataStack?
    var entry: Entry?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        addTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if model?.creationLocation != nil {
            setupLocation()
        }
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEntry))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
        navigationItem.setLeftBarButton(backButton, animated: false)
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func setupLocation() {
        if let model = model, let location = model.creationLocation {
            locationLabel.isHidden = false
            editLocationButton.isHidden = false
            addLocationButton.isHidden = true
            locationLabel.text = location
        } else {
            locationLabel.isHidden = true
            editLocationButton.isHidden = true
            addLocationButton.isHidden = false
        }
    }
    
    // TODO: Move to private extension
    private func setupView() {
        guard let model = model else {
            return
        }
        self.entryDateLabel.text = model.date
        self.entryTextView.text = model.entry
        entryImageView.image = model.image == nil ? #imageLiteral(resourceName: "photoAlbum") : model.image
        moodButtonArray.forEach { button in
            if let button = button, button.restorationIdentifier == model.mood {
                moodSelected(sender: button)
            }
        }
        
        // Clear out new entry's text
        if let entry = entry,
            !entry.isEdited {
            entryTextView.text = ""
        }
        
        if entry == nil {
            entryTextView.text = ""
        }
        
        setupLocation()
    }
    
    func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        entryImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func pickImage() {
        photoPickerManager.presentImagePickingOptions()
    }
    
    @objc func cancelEntry() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func saveEntry() {
        guard let coreDataStack = coreDataStack else {
            return
        }
        
        defer {
            coreDataStack.managedObjectContext.saveChanges()
            navigationController?.popToRootViewController(animated: true)
        }
        
        
        // TODO: Break out as much as you can, function too long
        var selectedMood = ""
        moodButtonArray.forEach({
            if $0?.isSelected ?? false {
                selectedMood = $0?.restorationIdentifier ?? ""
            }
        })
        
        guard let entry = entry else {
            let date = entryDateLabel.text ?? ""
            let model = EntryModel(date: date, entry: entryTextView.text, mood: selectedMood)
            Entry.with(model, in: coreDataStack.managedObjectContext, isEdited: true)
            return
        }
        
        entry.setValue(entryTextView.text, forKey: "entry")
        entry.setValue(selectedMood, forKey: "mood")
        entry.setValue(1, forKey: "isEdited")
        
        if let creationLocation = model?.creationLocation {
            entry.setValue(creationLocation, forKey: "creationLocation")
        }
        
        if let image = entryImageView.image, let imageData = image.jpegData(compressionQuality: 1.0) {
            entry.setValue(imageData, forKey: "image")
        }
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

extension DetailViewController: PhotoPickerManagerDelegate {
    func photoPickerManager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        photoPickerManager.dismissPhotoPicker(animated: true, completion: nil)
        entryImageView.image = image
    }
    
    
}
