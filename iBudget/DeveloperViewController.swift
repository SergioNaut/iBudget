//
//  DeveloperViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-03-19.
//

import Foundation
import UIKit

class DeveloperViewController: UIViewController {
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func contactUs(_ sender: UIButton) {
        //TODO: Change email
        let contactEmail = "foo@bar.com"
        let contactEmailURL = URL(string: "mailto://\(contactEmail)")!
        if UIApplication.shared.canOpenURL(contactEmailURL){
            UIApplication.shared.open(contactEmailURL)
        }
        
    }
    
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
            }
    }
}
