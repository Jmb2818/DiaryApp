//
//  DiaryErrors.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/22/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import Foundation

enum DiaryError: Error {
    case locationError
    case noCamera
    
    var errorTitle: String {
        switch self {
        case .locationError:
            return "Location Error"
        case .noCamera:
            return "Warning"
        }
    }
    
    
    var errorMessage: String {
        switch self {
        case .locationError:
            return "There was an error trying to get your location. Please try again"
        case .noCamera:
            return "You do not have a camera."
        }
    }
}
