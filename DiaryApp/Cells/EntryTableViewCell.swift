//
//  EntryTableViewCell.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/9/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryPassage: UILabel!
    @IBOutlet weak var entryMoodImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var geoLocationImageView: UIImageView!
    @IBOutlet weak var createdOrEditedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        geoLocationImageView.isHidden = true
        entryMoodImageView.isHidden = true
        locationLabel.isHidden = true
        entryImageView.layer.masksToBounds = false
        entryImageView.layer.cornerRadius = 50
        entryImageView.clipsToBounds = true
    }
    
    // MARK: Helper Functions
    ///Configure the entry cell with the EntryModel for the cell
    func configureWith(_ model: EntryModel, isEdited: Bool) {
        // Setup most of the labels and image
        let textColor = isEdited ? #colorLiteral(red: 0.4748743773, green: 0.4748743773, blue: 0.4748743773, alpha: 1) : #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        self.entryDate.text = model.date
        self.entryPassage.textColor = textColor
        self.entryMoodImageView.image = model.moodImage
        entryImageView.image = model.image == nil ? #imageLiteral(resourceName: "photoAlbum") : model.image
        
        // Setup the mood
        if model.mood != "" {
            self.entryMoodImageView.isHidden = false
            self.entryMoodImageView.image = model.moodImage
        } else {
            self.entryMoodImageView.isHidden = true
        }
        
        // Setup the location
        if let location = model.creationLocation {
            locationLabel.isHidden = false
            geoLocationImageView.isHidden = false
            self.locationLabel.text = location
        } else {
            locationLabel.isHidden = true
            geoLocationImageView.isHidden = true
        }
        
        // Setup the edited on date section
        if let editedDate = model.editedDate {
            createdOrEditedDateLabel.isHidden = false
            createdOrEditedDateLabel.text = "Edited On: \(editedDate)"
        } else {
            createdOrEditedDateLabel.isHidden = true
        }
        
        self.entryPassage.text = model.entry
    }
}
