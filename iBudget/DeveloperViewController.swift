//
//  DeveloperViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-03-19.
//

import Foundation
import UIKit

class DeveloperViewController: UIViewController {
    
    
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
            }
    }
}
