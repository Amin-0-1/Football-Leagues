//
//  UIViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

extension UIViewController{
    var indicator:UIActivityIndicatorView{
        let indicator = ActivityIndicator.shared.set().build()
        DispatchQueue.main.async {
            self.view.addSubview(indicator)
            indicator.center = self.view.center
        }
        return indicator
    }
    
    func showProgress(){
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = false
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideProgress(){
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showError(message:String,completion:@escaping()->Void = {}){
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Opps!!", message: message , preferredStyle: .alert)
            controller.addAction(.init(title: "OK", style: .default,handler: { _ in
                completion()
            }))
            self.present(controller, animated: true)
        }
    }
}

