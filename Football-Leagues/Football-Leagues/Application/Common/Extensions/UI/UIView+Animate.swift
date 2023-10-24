//
//  UIView+Animate.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import UIKit

extension UIView{
    func animate(closure: @escaping()->Void,completion: @escaping()->Void){
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            closure()
        }completion: { _ in
            completion()
        }
    }
}
