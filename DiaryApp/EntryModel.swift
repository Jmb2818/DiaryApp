//
//  EntryModel.swift
//  DiaryApp
//
//  Created by Joshua Borck on 5/15/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

struct EntryModel {
    let date: String
    var entry: String
    var mood: String
    let creationLocation: String
    
    var moodImage: UIImage? {
        switch mood {
        case "Bad":
            return #imageLiteral(resourceName: "badIcon")
        case "Good":
            return #imageLiteral(resourceName: "happyIcon")
        case "Average":
            return #imageLiteral(resourceName: "neutralIcon")
        default:
            return nil
        }
    }
    
    init(entry: Entry) {
        self.date = entry.date
        self.entry = entry.entry
        self.mood = entry.mood
        self.creationLocation = entry.creationLocation
    }
    
    init(date: String, entry: String, mood: String) {
        self.date = date
        self.entry = entry
        self.mood = mood
        self.creationLocation = ""
    }
    
}
