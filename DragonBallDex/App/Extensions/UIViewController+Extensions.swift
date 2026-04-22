//
//  UIViewController+Extensions.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 21/04/26.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
