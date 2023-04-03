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
import LocalAuthentication
import AVFAudio

class SettingViewController: UITableViewController {
    
    //Version Number Label - current version 1.5.2
    @IBOutlet weak var userName: UITextField!{
        didSet { userName?.addSaveToolbar(onDone: (target: self, action: #selector(onSaveTapped))) }
    }
    @IBOutlet weak var userBudget: UITextField!{
        didSet { userBudget?.addSaveToolbar(onDone: (target: self, action: #selector(onSaveTapped))) }
    }
    @IBOutlet weak var userIncome: UITextField!{
        didSet { userIncome?.addSaveToolbar(onDone: (target: self, action: #selector(onSaveTapped))) }
    }
    @IBOutlet weak var shareAppSelector: UIView!
    
    @IBOutlet weak var secureContent: UISwitch!
    
    @IBOutlet weak var appVersion: UILabel!
    
    @IBOutlet weak var appBuildNumber: UILabel!
    var userSavedName = ""
    var userSavedBudget = 0.0, userSavedIncome = 0.0
    var userSavedSecurityEnabled = false
    
    override func viewDidLoad() {
        tableView.rowHeight = 60
//        let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
//        NotificationPresenter.shared().present(title: "Player II", subtitle: "Connected")
//        NotificationPresenter.shared().displayLeftView(image)
         
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDeveloperPopup(_:)))
                onDevelopersPressed.addGestureRecognizer(guestureRecognizer)
        appVersion.text = "\(Bundle.main.versionNumber)"
        appBuildNumber.text="\(Bundle.main.buildNumber)"
        let shareAppRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareApp(_:)))
        shareAppSelector.addGestureRecognizer(shareAppRecognizer)
        getUserInfo()
    }
    
    @objc func shareApp(_ sender: Any){
            
            let title = "IBudget (Share Expense)"
         
            let text = "Hello \(UserDefaults().string(forKey: "fullname")!) is sharing this app with  you: "
            let appUrl = "https://apps.apple.com/us/developer/chris-glaze/id1333319093"
            
            // set up activity view controller
            let textToShare: [Any] = [
                MyActivityItemSource(title: title, text: text + appUrl)
            ]
           
            //let objectsToShare: [Any] = [textToShare, expenseDetails]
            
            let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            //let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.title = "Share Expense"
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.barButtonItem?.title  = "Share Expense"
            self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func securityToggled(_ sender: Any) {
        
        if secureContent.isOn {
            authenticateUser() 
        }else {
            UserDefaults().set(false, forKey: "secured")
            self.showSuccessMsg(msgTitle: "Biometric Access disabled!", imgName: "lock.open.fill")
            saveUserInfo()
        }
       
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:  &error) {
            let reason = "identify yourself !"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success,
                authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.saveUserInfo()
                        self?.showSuccessMsg(msgTitle: "Biometric access enabled", imgName: "lock.fill")
                        self?.secureContent.isOn = true
                        self?.playSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self?.dismiss(animated: true, completion: nil)
                        }
                        UserDefaults().set(true, forKey: "secured")
                        
                        
                    }else{
                        //error
                        let ac = UIAlertController(title: "Authentication failed", message: "user verification failed; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                        UserDefaults().set(false, forKey: "secured")
                        self?.secureContent.isOn = false
                        self?.showSuccessMsg(msgTitle: "Biometric access not enabled !", imgName: "xmark.circle")
                    }
                }
                
            }
            
        }
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    var completeEffect: AVAudioPlayer?

    
    func playSound() {
        // Load a local sound file
        let path = Bundle.main.path(forResource: "click.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            completeEffect = try AVAudioPlayer(contentsOf: url)
            completeEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func getUserInfo() {
        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest ()
            do {
                let exps = try getContext().fetch(request)
    
                for exp in exps{
                    userName.text = exp.fullName
                    userSavedName = exp.fullName ?? ""
                    userSavedBudget = exp.budget as! Double
                    userSavedIncome = exp.income as! Double
                    userBudget.text = formatDouble(exp.budget as! Double)
                    userIncome.text = formatDouble(exp.income as! Double)
                    userSavedSecurityEnabled =  exp.secured
                    secureContent.isOn = exp.secured
                }
            } catch {
                print ("error fetching data: \(error)")
            }
    }
    
    func showSuccessMsg(msgTitle : String,imgName : String ){
        NotificationPresenter.shared().present(title: msgTitle, subtitle: "", includedStyle: .dark)
        if(!imgName.isEmpty)
        { 
            let imageView = UIImageView(image: UIImage(systemName: imgName)?.withTintColor(.orange, renderingMode: .alwaysOriginal))
            imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            NotificationPresenter.shared().displayLeftView(imageView)
        }
        NotificationPresenter.shared().dismiss(afterDelay: 3)
    }
    
    func showErrorMsg(title: String, msg: String){
       
            let image = UIImage(named: "logo")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)

            NotificationPresenter.shared().present(title: title, subtitle: msg, includedStyle: .error)
//            NotificationPresenter.shared().displayLeftView(imageView)
            NotificationPresenter.shared().dismiss(afterDelay: 5)
        
    }
    
    @objc func onSaveTapped(_ sender: Any){
        saveUserInfo()
        userBudget.resignFirstResponder()
        userIncome.resignFirstResponder()
        userName.resignFirstResponder()
    }
    
    func saveUserInfo(){
        //Get users fullname
        let fullname = userName.text!
        

//        Get users income
        let income = NSDecimalNumber(string: userIncome.text == "" ? "0" : userIncome.text)
        let tmp_income = Double(truncating: income)
        
//        Get users budget
        let budget = NSDecimalNumber(string: userBudget.text == "" ? "0" : userBudget.text)
        let tmp_budget = Double(truncating: budget)
        
        if(fullname == userSavedName && tmp_budget == userSavedBudget && tmp_income == userSavedIncome && userSavedSecurityEnabled == secureContent.isOn ){
            return
        }
         
        if(fullname == ""){
            showErrorMsg(title:"Missing Value",msg: "Please enter your full name.")
            userName.text = userSavedName
            return
        }else if tmp_income.isNaN {
            showErrorMsg(title:"Invalid Input",msg: "Please enter a valid monthly income.")
            userIncome.text = formatDouble(userSavedIncome)
            return
        }
        else if tmp_budget.isNaN {
            showErrorMsg(title:"Invalid Input",msg: "Please enter a valid monthly budget.")
            userBudget.text = formatDouble(userSavedBudget)
            return
        }
        else if tmp_income < 1  {
            showErrorMsg(title:"Missing Value",msg: "Please enter your total monthly income.")
            userIncome.text = formatDouble(userSavedIncome)
            return
        }
        
        else if (tmp_budget < 1 ){
            showErrorMsg(title:"Missing Value",msg: "Please enter your total monthly budget.")
            userBudget.text = formatDouble(userSavedBudget)
            return
        }
        
        userSavedSecurityEnabled = secureContent.isOn
        
        let userinfo = UserInfo(context: getContext())
        userinfo.fullName = fullname.glazeCamelCase
        userinfo.income =  income
        userinfo.id = UUID()
        userinfo.budget = budget
        userinfo.secured = secureContent.isOn
        UserDefaults().setValue(fullname.glazeCamelCase, forKey: "fullname")
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        showSuccessMsg(msgTitle: "User info saved successfully!", imgName: "hand.thumbsup.fill")
        getUserInfo()
    }
    
    func formatDouble(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", number)
        } else {
            return String(format: "%.2f", number)
        }
    }

    

    @IBOutlet weak var onDevelopersPressed: UIView!
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.red // set your desired color here
    }
    
    @objc func openDeveloperPopup(_ sender: Any){
        //help page open
        performSegue(withIdentifier: "goToHelp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "goToHelp"{
            let destinationVC = segue.destination as? DeveloperViewController
        }
           
    }
    
    @IBAction func clearData(_ sender: UIButton) {
        restartApp()
    }
    
    func restartApp() {
        
        let alertController = UIAlertController(title: "Erase All Data", message: "Are you sure you want to erase all user data?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Erase All Data", style: .destructive) { (action) in
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
            UserDefaults().set(false, forKey: "locked")
            UserDefaults().set(false, forKey: "secured")
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

extension UITextField {
    func addSaveToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
//            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Save", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
}
