//
//  markAndCookingView.swift
//  Reciplease
//
//  Created by jullianm on 17/12/2017.
//  Copyright © 2017 jullianm. All rights reserved.
//

import UIKit

@IBDesignable
class markAndCookingView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}
