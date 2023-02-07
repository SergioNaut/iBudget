//
//  UIExtensions.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 28/01/2023.
//

import Foundation
import UIKit

extension UIImage {
  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
 
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

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
    
    @IBInspectable
      var shadowRadius: CGFloat {
        get {
          return layer.shadowRadius
        }
        set {
          layer.shadowRadius = newValue
        }
      }
      
      @IBInspectable
      var shadowOpacity: Float {
        get {
          return layer.shadowOpacity
        }
        set {
          layer.shadowOpacity = newValue
        }
      }
      
      @IBInspectable
      var shadowOffset: CGSize {
        get {
          return layer.shadowOffset
        }
        set {
          layer.shadowOffset = newValue
        }
      }
      
      @IBInspectable
      var shadowColor: UIColor? {
        get {
          if let color = layer.shadowColor {
            return UIColor(cgColor: color)
          }
          return nil
        }
        set {
          if let color = newValue {
            layer.shadowColor = color.cgColor
          } else {
            layer.shadowColor = nil
          }
        }
      }
    
}



