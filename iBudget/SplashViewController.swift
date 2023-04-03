//
//  SplashViewController.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 02/04/2023.
//

import Foundation
import UIKit

class SplashViewController : UIViewController {
    
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblCopyrightInfo: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        lblAppVersion.text = "\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)"
        
    }
}
