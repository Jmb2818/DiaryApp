//
//  ViewController+Extensions.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/22/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Function for any UIViewController to present a UIAlert with a title and message
    func presentAlert(title: String?, message: String) {
        let errorTitle = title ?? UserStrings.Error.error
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UserStrings.Error.okTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
