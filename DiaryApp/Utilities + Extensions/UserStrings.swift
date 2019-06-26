//
//  UserStrings.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/22/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

class UserStrings {
    enum General {
        static let lineBreak = "\n"
        static let noCharacters = "0/200"
        static let someCharacters = "/200"
    }
    
    enum PhotoManager {
        static let chooseImage = "Choose Image"
        static let camera = "Camera"
        static let photoGallery = "Photo Gallery"
        static let cancel = "Cancel"
    }
    
    enum Location {
        static let selectALocation = "Tap To Select A Location"
    }
    
    enum Mood {
        static let bad = "Bad"
        static let good = "Good"
        static let average = "Average"
    }
    
    enum Error {
        static let okTitle = "OK"
        static let error = "Error"
    }
}
