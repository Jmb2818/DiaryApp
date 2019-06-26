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
    @IBOutlet weak var characterCountLabel: UILabel!
    
    lazy var moodButtonArray = [goodButton, averageButton, badButton]
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()
    
    var model: EntryModel?
    var coreDataStack: CoreDataStack?
    var entry: Entry?
    private var isEditedEntry: Bool = false
    
    var textViewTextCount: Int {
        return entryTextView.text.count
    }
    
    
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
        updateCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        entryTextView.endEditing(true)
    }
    
    // MARK: Actions
    /// Function to present image picker
    @objc func pickImage() {
        photoPickerManager.presentImagePickingOptions()
    }
    
    /// Function to cancel and pop back to master view
    @objc func cancelEntry() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Function to save an entry
    @objc func saveEntry() {
        guard let coreDataStack = coreDataStack else {
            return
        }
        
        // Always save changes and pop back to master view
        defer {
            coreDataStack.managedObjectContext.saveChanges()
            navigationController?.popToRootViewController(animated: true)
        }
        
        let selectedMood = getSelectedMood()
        
        guard let entry = entry else {
            // If there is no entry passed in create a new one
            let date = entryDateLabel.text ?? ""
            var model = self.model ?? EntryModel(date: date, entry: entryTextView.text, mood: selectedMood)
            model.entry = entryTextView.text
            model.mood = selectedMood
            Entry.with(model, in: coreDataStack.managedObjectContext, isEdited: true)
            return
        }
        
        // If this is an edited entry, update the edited on date
        if entry.isEdited {
            let todaysDate = DateEditor.monthDayYearFrom(Date())
            entry.setValue(todaysDate, forKey: EntryKeys.editedDate.rawValue)
        }
        entry.setValue(entryTextView.text, forKey: EntryKeys.entry.rawValue)
        entry.setValue(selectedMood, forKey: EntryKeys.mood.rawValue)
        entry.setValue(1, forKey: EntryKeys.isEdited.rawValue)
        
        // Update location if available
        if let creationLocation = model?.creationLocation {
            entry.setValue(creationLocation, forKey: EntryKeys.creationLocation.rawValue)
        }
        
        // Update image for entry
        if let image = entryImageView.image, let imageData = image.jpegData(compressionQuality: 1.0) {
            entry.setValue(imageData, forKey: EntryKeys.image.rawValue)
        }
    }
    
    // MARK: IBActions
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


private extension DetailViewController {
    // MARK: View Set Up
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
    
    func setupView() {
        guard let model = model else {
            return
        }
        self.entryTextView.delegate = self
        self.entryDateLabel.text = model.date
        self.entryTextView.text = model.entry
        self.entryTextView.text = model.entry
        entryImageView.image = model.image == nil ? #imageLiteral(resourceName: "photoAlbum") : model.image
        moodButtonArray.forEach { button in
            if let button = button, button.restorationIdentifier == model.mood {
                moodSelected(sender: button)
            }
        }
        
        if let entry = entry {
            isEditedEntry = entry.isEdited
        }
        
        setupLocation()
    }
    
    /// Function to update count of characters
    func updateCount() {
        guard isEditedEntry else {
          characterCountLabel.text = UserStrings.General.noCharacters
            return
        }
        let count = String(textViewTextCount)
        characterCountLabel.text = [count, UserStrings.General.someCharacters].joined()
    }
    
    func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        entryImageView.addGestureRecognizer(tapGesture)
    }
    
    /// Function to get selected mood if there is one
    func getSelectedMood() -> String {
        var selectedMood = ""
        moodButtonArray.forEach({
            if $0?.isSelected ?? false {
                selectedMood = $0?.restorationIdentifier ?? ""
            }
        })
        return selectedMood
    }

    /// Reset mood buttons to not be selected
    func resetMoodButtons() {
        moodButtonArray.forEach { button in
            button?.layer.borderWidth = 0
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.isSelected = false
        }
    }
}

// MARK: PhotoPickerManagerDelegate Conformance
extension DetailViewController: PhotoPickerManagerDelegate {
    func photoPickerManager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        photoPickerManager.dismissPhotoPicker(animated: true, completion: nil)
        entryImageView.image = image
    }
}

// MARK: UITextViewDelegate Conformance
extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Make sure return dismisses the keyboard
        if text == UserStrings.General.lineBreak {
            textView.resignFirstResponder()
            return false
        }
        
        if text == "" {
            return true
        }
        return textViewTextCount <= 199
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Clear out new entry's text if needed
        if !isEditedEntry {
            entryTextView.text = ""
        }
        
        isEditedEntry = true
        
        if entry == nil {
            entryTextView.text = ""
        }
        
        entryTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        updateCount()
    }
    func textViewDidChange(_ textView: UITextView) {
        updateCount()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateCount()
    }
}
