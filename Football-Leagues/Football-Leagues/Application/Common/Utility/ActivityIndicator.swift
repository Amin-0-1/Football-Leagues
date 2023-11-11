//
//  ActivityIndicator.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

class ActivityIndicator{
    static let shared = ActivityIndicator()
    private let indicator: UIActivityIndicatorView
    private init(){
        indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
    }
    func set(color:UIColor = .green,style:UIActivityIndicatorView.Style = .large)->ActivityIndicator{
        indicator.color = color
        indicator.style = style
        return self
    }
    func build()->UIActivityIndicatorView{
        return self.indicator
    }
    
}
