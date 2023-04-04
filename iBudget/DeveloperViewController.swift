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
        let contactEmail = "group6@fanshaweonline.ca"
        let subject = "iBudget App Feedback"
        let body = "Hi, I have a feedback for iBudget App"
        let email = "mailto:\(contactEmail)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        if let url = URL(string: email) {
            UIApplication.shared.open(url)
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
