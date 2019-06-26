//
//  EntryModel.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/15/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

/// A model to create from an entry and set all the correct values for the UI
struct EntryModel {
    
    // MARK: Properties
    let date: String
    var entry: String
    var mood: String
    var creationLocation: String?
    var image: UIImage?
    var editedDate: String?
    
    var moodImage: UIImage? {
        switch mood {
        case UserStrings.Mood.bad:
            return #imageLiteral(resourceName: "badIcon")
        case UserStrings.Mood.good:
            return #imageLiteral(resourceName: "happyIcon")
        case UserStrings.Mood.average:
            return #imageLiteral(resourceName: "neutralIcon")
        default:
            return nil
        }
    }
    
    // MARK: Initializers
    init(entry: Entry) {
        self.date = entry.date
        self.entry = entry.entry
        self.mood = entry.mood
        self.creationLocation = entry.creationLocation
        self.image = entry.entryImage
        self.editedDate = entry.editedDate
    }
    
    init(date: String, entry: String, mood: String) {
        self.date = date
        self.entry = entry
        self.mood = mood
        self.creationLocation = nil
        self.editedDate = date
    }
    
}
