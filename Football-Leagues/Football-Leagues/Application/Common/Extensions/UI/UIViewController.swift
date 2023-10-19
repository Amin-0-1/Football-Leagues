//
//  UIViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

extension UIViewController{
    var indicator:UIActivityIndicatorView{
        let indicator = ActivityIndicator.shared.color(color: .systemGreen).build()
        view.addSubview(indicator)
        indicator.center = view.center
        return indicator
    }
    
    func showProgress(){
        indicator.startAnimating()
        indicator.isHidden = false
        view.isUserInteractionEnabled = false
    }
    
    func hideProgress(){
        indicator.stopAnimating()
        indicator.isHidden = true
        view.isUserInteractionEnabled = true
    }
    
    func showError(message:String){
        let controller = UIAlertController(title: "An Error Occured", message: message , preferredStyle: .alert)
        controller.addAction(.init(title: "OK", style: .default))
        present(controller, animated: true)
    }
}

