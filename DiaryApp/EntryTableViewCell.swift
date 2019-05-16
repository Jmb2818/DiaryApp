//
//  EntryTableViewCell.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/9/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryPassage: UILabel!
    @IBOutlet weak var entryMoodImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var geoLocationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        geoLocationImageView.isHidden = true
        entryMoodImageView.isHidden = true
        locationLabel.isHidden = true
        entryImageView.layer.masksToBounds = false
        entryImageView.layer.cornerRadius = 50
        entryImageView.clipsToBounds = true
    }
    
    func configureWith(_ model: EntryModel) {
        self.entryDate.text = model.date
        self.entryMoodImageView.image = model.moodImage
        if model.mood != "" {
            self.entryMoodImageView.isHidden = false
            self.entryMoodImageView.image = model.moodImage
        } else {
            self.entryMoodImageView.isHidden = true
        }
        self.entryPassage.text = model.entry
    }
}
