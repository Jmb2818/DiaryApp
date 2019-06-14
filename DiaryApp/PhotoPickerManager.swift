//
//  PhotoPickerManager.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/12/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
    
}

class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    private let controller: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.controller = presentingViewController
        super.init()
        configure()
    }
    
    private func configure() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        imagePickerController.delegate = self
    }
    
    func presentPhotoPicker(animated: Bool) {
        controller.present(imagePickerController, animated: animated, completion: nil)
    }
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
