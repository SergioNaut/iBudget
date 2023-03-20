//
//  SettingViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-01-31.
//

import Foundation
import UIKit
import JDStatusBarNotification
import CoreData

class SettingViewController: UITableViewController {
    
    //Version Number Label - current version 1.5.2
    
    override func viewDidLoad() {
        tableView.rowHeight = 60
//        let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
//        NotificationPresenter.shared().present(title: "Player II", subtitle: "Connected")
//        NotificationPresenter.shared().displayLeftView(image)
         
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDeveloperPopup(_:)))
                onDevelopersPressed.addGestureRecognizer(guestureRecognizer)

        
    }

    @IBOutlet weak var onDevelopersPressed: UIView!
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.red // set your desired color here
    }
    
    @objc func openDeveloperPopup(_ sender: Any){
        //help page open
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
//            let destinationVC = segue.destination as? AddExpenseViewControlller
           
    }
    
    @IBAction func clearData(_ sender: UIButton) {
        restartApp()
    }
    
    func restartApp() {
        
        let alertController = UIAlertController(title: "Notification", message: "Are you sure you want to clear all user data and start afresh.", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Clear Data", style: .destructive) { (action) in
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
                self.resetAllRecords(in: "Categories")
                self.resetAllRecords(in: "Expenses")
                self.resetAllRecords(in: "UserInfo")
            }
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = viewController
                window.makeKeyAndVisible()

                let _: UIViewController? = nil

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "userOnboarding") as! ViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(mainTabBarController)

                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: false, completion: nil)
            }
        }
        alertController.addAction(logoutAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
        }

    }

    func resetAllRecords(in entity : String) 
        {

            let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
    
}
