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
}
