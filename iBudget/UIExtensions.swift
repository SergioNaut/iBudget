//
//  UIExtensions.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 28/01/2023.
//

import Foundation
import UIKit


@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}
