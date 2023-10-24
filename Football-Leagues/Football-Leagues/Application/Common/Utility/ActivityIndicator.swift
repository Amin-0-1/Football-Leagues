//
//  ActivityIndicator.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

class ActivityIndicator{
    static let shared = ActivityIndicator()
    private let indicator: UIActivityIndicatorView!
    private init(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .cyan
        indicator.hidesWhenStopped = true
    }
    func color(color :UIColor) -> ActivityIndicator{
        indicator.color = color
        return self
    }
    func build()->UIActivityIndicatorView{
        return self.indicator
    }
    
}
