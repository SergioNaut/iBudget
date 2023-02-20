//
//  CustomTabBarVC.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 02/02/2023.
//

import Foundation
import UIKit


class CustomTabBarController : UITabBarController,UITabBarControllerDelegate{
    
    
    override func viewDidLoad() {
        self.delegate = self
//        self.tabBar.tintColor = UIColor.black
//        self.tabBar.t
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let items = tabBar.items {
                // Setting the title text color of all tab bar items:
                for item in items {
                    
                    item.setTitleTextAttributes([ .font: UIFont(name: "Avenir Medium", size: 12)! ], for: .selected)
                    item.setTitleTextAttributes([ .font: UIFont(name: "Avenir Medium", size: 12)!], for: .normal)
                    item.setTitleTextAttributes([.font: UIFont(name: "Avenir Medium", size: 12)!], for: .normal)
                }
            }
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellow]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        self.tabBar.isTranslucent = true
        }
    
    
    
}
