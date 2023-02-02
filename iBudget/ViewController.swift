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
        saveDefault()
        // Do any additional setup after loading the view.
        
    }

    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtIncome: UITextField!
    
    @IBAction func saveUserInfo(_ sender: Any) {
           
       
        
        //Get users fullname
        let fullname = txtFullname.text!

        //Get users income
        let income = NSDecimalNumber(string: txtIncome.text!)

        //Get users budget
        let budget = NSDecimalNumber(string: txtBudget.text!)

        let userinfo = UserInfo(context: getContext())
        userinfo.fullName = fullname
        userinfo.income =  income
        userinfo.id = UUID()
        userinfo.budget = budget
        UserDefaults().setValue(fullname, forKey: "fullame")
        self.saveAll()
        
        performSegue(withIdentifier: "dashboard", sender: self)
        
 
    }
    
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    
    func saveDefault(){
        
                let category = Categories(context: getContext())
                category.name = "Food"
                category.type = 1
                var id = UUID()
                category.id = id
        
        
                let exp = Expenses(context: getContext())
                exp.name = "Watermelon"
                exp.categoryId = id
                exp.categoryName = "Food"
                exp.amount = 10.23
                exp.created = Date()
        
                let exp4 = Expenses(context: getContext())
                exp4.name = "Bread"
                exp4.categoryId = id
                exp4.categoryName = "Food"
                exp4.amount = 8.99
                exp4.created = Date()
        
        
                let category2 = Categories(context: getContext())
                category2.name = "Utilities"
                category2.type = 1
                id = UUID()
                category2.id = id
        
                let exp2 = Expenses(context: getContext())
                exp2.name = "Hydro Electricity"
                exp2.categoryId = id
                exp2.categoryName = "Utilities"
                exp2.amount = 45.12
                exp2.created = Date()
        
                let exp3 = Expenses(context: getContext())
                exp3.name = "Water"
                exp3.categoryName = "Utilities"
                exp3.categoryId = id
                exp3.amount = 78.03
                exp3.created = Date()
                
                self.saveAll()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashboard" {
            _ = segue.destination as? DashboardViewController
           // destinationVC?.weatherResponse = weatherResponse
        }
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
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "dashboard", sender: self)
                }
                
            }
            

             
        } catch {
            print ("error fetching data: \(error)")
        }
    }
    
    
    func saveAll(){
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
         
        print("Saved")
        //getUserInfo()
        print("Loaded")

 
    }
    
   
}
 

