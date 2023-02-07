//
//  ViewController.swift
//  iBudget
//
//  Created by Salem Kosemani on 2023-01-15.
//

import UIKit
import CoreData




class ViewController: UIViewController {

   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        //saveDefault()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()

    }

    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtIncome: UITextField!
    
    @IBAction func saveUserInfo(_ sender: Any) {
           
        
        DispatchQueue.main.async {
        
            self.txtFullname.backgroundColor = UIColor.white
            self.txtIncome.backgroundColor = UIColor.white
            self.txtBudget.backgroundColor = UIColor.white
            
        }
        //Get users fullname
        let fullname = txtFullname.text!

        //Get users income
        let income = NSDecimalNumber(string: txtIncome.text!)

        //Get users budget
        let budget = NSDecimalNumber(string: txtBudget.text!)

       
        
        if(fullname == ""){
            showMsg(txtField: txtFullname,msg: "Please enter your fullname")
            return
        }else if (Float(truncating: income) < 1){
            showMsg(txtField: txtIncome,msg: "Please enter your total monthly income")
            return
        }else if (Float(truncating: budget) < 1){
            showMsg(txtField: txtBudget,msg: "Please enter your total monthly budget")
            return
        }
//        }else if (Float(truncating: budget) >  Float(truncating: income) ){
//            showMsg(txtField: txtBudget,msg: "Budget should be less or same as your income")
//            return
//        }
//
         
        
        
        let userinfo = UserInfo(context: getContext())
        userinfo.fullName = fullname
        userinfo.income =  income
        userinfo.id = UUID()
        userinfo.budget = budget
        UserDefaults().setValue(fullname, forKey: "fullname")
        
        let category = Categories(context: getContext())
        category.name = "Food"
        //Set type as 0 because they are the predefined categories
        category.type = 0
        var id = UUID()
        category.id = id
        //TODO: Change icons
        category.icon = "fork.knife"
        
        let category2 = Categories(context: getContext())
        category2.name = "Housing"
        //Set type as 0 because they are the predefined categories
        category2.type = 0
        id = UUID()
        category2.id = id
        //TODO: Change icons
        category2.icon = "house"
        
        let category3 = Categories(context: getContext())
        category3.name = "Transportation"
        //Set type as 0 because they are the predefined categories
        category3.type = 0
        id = UUID()
        category3.id = id
        //TODO: Change icons
        category3.icon = "car"
        
        let category4 = Categories(context: getContext())
        category4.name = "Utilities"
        //Set type as 0 because they are the predefined categories
        category4.type = 0
        id = UUID()
        category4.id = id
        //TODO: Change icons
        category4.icon = "wrench.and.screwdriver"
        
        let category5 = Categories(context: getContext())
        category5.name = "Medical"
        //Set type as 0 because they are the predefined categories
        category5.type = 0
        id = UUID()
        category5.id = id
        //TODO: Change icons
        category5.icon = "cross"
        
        self.saveAll()
        
        //performSegue(withIdentifier: "dashboard", sender: self)
        
        navigateToMainView()
      
 
    }
    
    
    
    
    func navigateToMainView(){
        
        let vc: UIViewController? = nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(mainTabBarController  )
    }
    
    
    
    func showMsg(txtField : UITextField, msg: String)
    {
        
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        // Present alert to user
        dialogMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
             // print("Handle Ok logic here")
              }))
        self.present(dialogMessage, animated: true, completion: nil)
        DispatchQueue.main.async {
            txtField.becomeFirstResponder()
            txtField.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        }
       
    }
    
    
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    
    
    
    
//    func saveDefault(){
//        
//                let category = Categories(context: getContext())
//                category.name = "Food"
//                category.icon = "fork.knife"
//        
//                category.type = 1
//                var id = UUID()
//                category.id = id
//        
//        
//                let exp = Expenses(context: getContext())
//                exp.name = "Watermelon"
//                exp.categoryId = id
//                exp.categoryName = "Food"
//                exp.amount = 10.23
//                exp.created = Date()
//        
//                let exp4 = Expenses(context: getContext())
//                exp4.name = "Bread"
//                exp4.categoryId = id
//                exp4.categoryName = "Food"
//                exp4.amount = 8.99
//                exp4.created = Date()
//        
//        
//                let category2 = Categories(context: getContext())
//                category2.name = "Utilities"
//                category2.type = 1
//                id = UUID()
//                category2.id = id
//        
//                let exp2 = Expenses(context: getContext())
//                exp2.name = "Hydro Electricity"
//                exp2.categoryId = id
//                exp2.categoryName = "Utilities"
//                exp2.amount = 45.12
//                exp2.created = Date()
//        
//                let exp3 = Expenses(context: getContext())
//                exp3.name = "Water"
//                exp3.categoryName = "Utilities"
//                exp3.categoryId = id
//                exp3.amount = 78.03
//                exp3.created = Date()
//                
//                self.saveAll()
//    }
//    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "dashboard" {
//            _ = segue.destination as? DashboardViewController
//           // destinationVC?.weatherResponse = weatherResponse
//        }
    }
    
    
    func getUserInfo(){
        
//        let request: NSFetchRequest<Expenses> = Expenses.fetchRequest ()
//        do {
//            let exps = try getContext().fetch(request)
//
//            for exp in exps{
//                print(exp.name!)
//            }
//
//        } catch {
//            print ("error fetching data: \(error)")
//        }
        
        
        
        let user_request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest ()
        do {
            let users = try getContext().fetch(user_request)
            
            if(users.count > 0)
            {
                for user in users{
                    UserDefaults().setValue(user.fullName, forKey: "fullame")
                }
                
//                DispatchQueue.main.async {
//                    self.navigateToMainView()
//                    //self.performSegue(withIdentifier: "dashboard", sender: self)
//                }
//
            }
            

             
        } catch {
            print ("error fetching data: \(error)")
        }
    }
    
    @IBAction func saveCategory(_ sender: Any) {
    }
    
    func saveAll(){
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
         
        print("Saved")
        //getUserInfo()
        print("Loaded")

 
    }
    
   
}
 

