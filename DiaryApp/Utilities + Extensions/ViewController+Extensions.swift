//
//  ViewController+Extensions.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/22/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String) {
        let errorTitle = title ?? "Error"
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
