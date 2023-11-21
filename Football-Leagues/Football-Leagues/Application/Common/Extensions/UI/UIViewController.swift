//
//  UIViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

extension UIViewController {
    
    var indicator: UIActivityIndicatorView {
        let indicator = ActivityIndicator.shared.set().build()
        DispatchQueue.main.async {
            self.view.addSubview(indicator)
            indicator.center = self.view.center
        }
        return indicator
    }
    
    /// show native activity indicator Progress and block the user interaction
    func showProgress() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = false
            self.view.isUserInteractionEnabled = false
        }
    }
    
    /// hide the activity indicator and enable user interation
    func hideProgress() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    /// present native alert controller with specified message
    /// - Parameters:
    ///   - message: alert message to show in the alert
    ///   - completion: completion block of code to be executed after dismissing the alert
    func showError(message: String, completion: @escaping() -> Void = {}) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Opps!!", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion()
            }
            controller.addAction(okAction)
            self.present(controller, animated: true)
        }
    }
}
