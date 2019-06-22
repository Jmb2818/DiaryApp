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
    func photoPickerManager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

class PhotoPickerManager: NSObject {
    private let imagePickerController = UIImagePickerController()
    private let controller: UIViewController
    private let actionSheet = UIAlertController(title: UserStrings.PhotoManager.chooseImage, message: nil, preferredStyle: .actionSheet)
    
    weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.controller = presentingViewController
        super.init()
        configure()
    }
    
    private func configure() {
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
        let cameraAction = UIAlertAction(title: UserStrings.PhotoManager.camera, style: .default) { [weak self] _ in
            self?.presentCamera()
        }
        
        let galleryAction = UIAlertAction(title: UserStrings.PhotoManager.photoGallery, style: .default) { [weak self] _ in
            self?.presentGallery()
        }
        
        let cancelAction = UIAlertAction(title: UserStrings.PhotoManager.cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
    }
    
    func presentImagePickingOptions() {
        controller.present(actionSheet, animated: true, completion: nil)
    }
    
    func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    private func presentPhotoPicker(animated: Bool) {
        controller.present(imagePickerController, animated: animated, completion: nil)
    }
    
    private func presentCamera() {
        actionSheet.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            presentPhotoPicker(animated: true)
        } else {
            let error = DiaryError.noCamera
            controller.presentAlert(title: error.errorTitle, message: error.errorMessage)
        }
    }
    
    private func presentGallery() {
        actionSheet.dismiss(animated: true, completion: nil)
        imagePickerController.sourceType = .photoLibrary
        presentPhotoPicker(animated: true)
    }
}

extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        delegate?.photoPickerManager(self, didPickImage: image)
    }
}
