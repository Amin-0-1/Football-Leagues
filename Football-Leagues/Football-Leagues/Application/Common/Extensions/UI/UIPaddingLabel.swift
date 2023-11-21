//
//  UIPaddingLabel.swift
//  Football-Leagues
//
//  Created by Amin on 23/10/2023.
//

import UIKit
class UIPaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var masksToBounds: Bool = false
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
    
    override var bounds: CGRect {
        didSet {
            layer.masksToBounds = masksToBounds
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
