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
      //  setupMiddleButton()
 
        // add these two lines
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
       
    }
    
    
    
    
    // TabBarButton – Setup Middle Button
        func setupMiddleButton() {
        
            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
        
            //STYLE THE BUTTON YOUR OWN WAY
            
            middleBtn.backgroundColor = UIColor(hex: "#FE7685ff")
            middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
            middleBtn.setImage(UIImage(systemName: "plus")?.withTintColor(.white), for: .normal)
            middleBtn.shadowColor = UIColor.gray
            middleBtn.shadowRadius = 10
            middleBtn.shadowOpacity = 1
            middleBtn.shadowOffset = CGSize(width: 0, height: 3)
            
            
            //add to the tabbar and add click event
            self.tabBar.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
            middleBtn.clipsToBounds = true

            self.view.layoutIfNeeded()
    }


    
    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 1   //to select the middle tab. use "1" if you have only 3 tabs.
        //print("MenuButton")
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
        self.tabBar.backgroundColor = .clear
        }
    
    
    
}
