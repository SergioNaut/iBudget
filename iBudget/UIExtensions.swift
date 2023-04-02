//
//  UIExtensions.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 28/01/2023.
//

import Foundation
import UIKit
import CoreData
 
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

//MARK:- IBInspectable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = true
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
extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}

extension UILabel {
    func typeOn(string: String) {
        let characterArray =  string.map(String.init)
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (timer) in
            if characterArray[characterIndex] != "$" {
                while characterArray[characterIndex] == " " {
                    self.text! += " "
                    characterIndex += 1
                    if characterIndex == characterArray.count {
                        timer.invalidate()
                        return
                    }
                }
                self.text! += characterArray[characterIndex]
            }
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
    }
}

extension Int {
    var abbreviated: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if self >= 1000 && self < 1000000 {
            // Convert to thousands
            formatter.maximumFractionDigits = 1
            return "\(formatter.string(from: NSNumber(value: Double(self)/1000))!)K"
        } else if self >= 1000000 {
            // Convert to millions
            formatter.maximumFractionDigits = 1
            return "\(formatter.string(from: NSNumber(value: Double(self)/1000000))!)M"
        } else {
            // No abbreviation needed
            return "\(self)"
        }
    }
}

func formatNumber(_ number: Double) -> String {
    let thousand = 1000.0
    let million = 1_000_000.0
    let billion = 1_000_000_000.0
    
    if number >= billion {
        // Format number for billions
        return String(format: "%.1fB", number / billion)
    } else if number >= million {
        // Format number for millions
        return String(format: "%.1fM", number / million)
    } else if number >= thousand {
        // Format number for thousands
        return String(format: "%.1fK", number / thousand)
    } else {
        // Format number as-is
        return String(format: "%.0f", number)
    }
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
    var getCurrentLongMonthName : String {
        let date = Date()
        return date.monthName() // Returns current month e.g. "May"
    }
}

extension Date {
    func currentYear() -> Int {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("YYYY")
        return Int( df.string(from: self) ) ?? 0
    }
}

extension Date {
    func shortMonthName() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return df.string(from: self)
    }
}


extension Date {
    func monthName() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
            return df.string(from: self)
    }
}

extension Date {
    func customfullDate() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("dd MMM yyyy")
            return df.string(from: self)
    }
}

extension Date {
    func dateOnly() -> Int {
        return Calendar.current.component(.day, from: self)
    }
}

extension Date {
    func monthIndex() -> Int {
       return Calendar.current.component(.month, from: self)
    }
}

extension Date {
    func Year() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("YYYY")
        return df.string(from: self)
    }
}

protocol MyDelegate : AnyObject {
    func menuButtonAction(sender : UIButton)
}


 
@IBDesignable
class CustomizedTabBar: UITabBar , MyDelegate {

    private var shapeLayer: CALayer?

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor(hex: "#F7F7F7FF")?.cgColor// as? CGColor ?? .white.cgColor
        shapeLayer.lineWidth = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
        self.setupMiddleButton()
    }

    func createPath() -> CGPath {

        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }

    func createPathCircle() -> CGPath {

        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    var middleBtn : UIButton!
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {
        
              middleBtn = UIButton(frame: CGRect(x: (self.bounds.width / 2)-25, y: -20, width: 50, height: 50))
        
            //STYLE THE BUTTON YOUR OWN WAY
            middleBtn.tintColor = .white
            middleBtn.backgroundColor = UIColor(hex: "#FE7685ff")
            middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
            middleBtn.setImage(UIImage(systemName: "plus")?.withTintColor(.white), for: .normal)
            //add to the tabbar and add click event
            self.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
            middleBtn.clipsToBounds = true

            self.layoutIfNeeded()
    }

    
    
    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        
        
         //let nextViewController = AddExpenseViewControlller()
        
         let rvc = self.window?.rootViewController
        
         //rvc?.performSegue(withIdentifier: "addExpense", sender: sender)
        
        let secondVC = rvc?.storyboard?.instantiateViewController(withIdentifier: "addExpense") as! AddExpenseViewControlller
        rvc!.present(secondVC, animated:true, completion:nil)

        
       // super.navigationController?.pushViewController(nextViewController,
           //  animated: false)
        
        //self.selectedIndex = 1   //to select the middle tab. use "1" if you have only 3 tabs.
       // let parent = sender.superview //as! CustomTabBarController
        // parent.performSegue(withIdentifier: "addExpense", sender: parent)
     
       // performSegue(withIdentifier: "addExpense", sender: self)
        //performSegue(withIdentifier: "addExpense", sender: nil)
       
       // actionPerformed(true)
        
//        let destinationVC = segue.destination as? AddExpenseViewControlller
//        destinationVC?.isEdit = isEdit
//        destinationVC?.editExpenseItem = selectedExpense
//
        //let vc = AddExpenseViewControlller()
       // openAddViewController()
       // self..navigationController?.pushViewController(vc, animated: true)
    }
    
    
     
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        for member in subviews.reversed()
        {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event)
                else { continue }
                return result
        }

        return nil
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//      let from = point
//      let to = middleBtn.center
//      return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 35 ? middleBtn : super.hitTest(point, with: event)
//    }
//
//
    
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

extension Int {
    func abbreviateNumber() -> String {
        var num = Double(self)
        let sign = ((num < 0) ? "-" : "")
        num = fabs(num)
        
        if num >= 1000000000 {
            let formatted = "\(sign)\(num / 1000000000.0)B"
            return formatted
        }
        else if num >= 1000000 {
            let formatted = "\(sign)\(num / 1000000.0)M"
            return formatted
        }
        else if num >= 1000 {
            let formatted = "\(sign)\(num / 1000.0)K"
            return formatted
        }
        else {
            return "\(sign)\(self)"
        }
    }
}

extension Double {
    func abbreviateNumber() -> String {
        var num = self
        let sign = ((num < 0) ? "-" : "")
        num = fabs(num)
        
        if num >= 1000000000 {
            let formatted = "\(sign)\(num / 1000000000.0)B"
            return formatted
        }
        else if num >= 1000000 {
            let formatted = "\(sign)\(num / 1000000.0)M"
            return formatted
        }
        else if num >= 1000 {
            let formatted = "\(sign)\(num / 1000.0)K"
            return formatted
        }
        else {
            return "\(sign)\(self)"
        }
    }
}

func getContext()->NSManagedObjectContext {
    let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
    return context
}

extension CustomTabBarController  {
    
    func openAddViewController() {
        let vc = AddExpenseViewControlller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
