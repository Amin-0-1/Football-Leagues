//
//  UIColor.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit
extension UIColor {
    enum ColorName: String {
        case mainColor
        case mainAuxilary
        case mainAuxilary2
        case blueColor
        case greenColor
        case purpleColor
    }
    
    static func customColor(_ name: ColorName) -> UIColor {
        return UIColor(named: name.rawValue) ?? .clear
    }
    static func getColor(name: String) -> UIColor? {
        switch name.lowercased() {
            case "red":
                return .red
            case "claret":
                return .systemRed
            case "green":
                return .green
            case "blue":
                return .blue
            case "yellow":
                return .yellow
            case "orange":
                return .orange
            case "gold":
                return .systemYellow
            case "purple":
                return .purple
            case "white":
                return .white
            case "black":
                return .black
            default:
                return .customColor(.purpleColor)
        }
    }
}
