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

func hexColor(hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let int = UInt32()
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension String {
    var glazeCamelCase: String {
        // 1
        
        let tmpArr = self.split(separator: " ")
        
        let words =  tmpArr.map  { $0.prefix(1).capitalized + $0.dropFirst().lowercased() }
         
        return words.joined(separator: " ")
    }
    
    
    var getCurrentShortMonth : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        return  dateFormatter.string(from: Date())
    }
}


