//
//  ViewController.swift
//  iBudget
//
//  Created by Salem Kosemani on 2023-01-15.
//

import UIKit
import CoreData




class ViewController: UIViewController {

   
    @IBOutlet weak var budgetVw: UIView!
    @IBOutlet weak var fullnameVw: UIView!

    @IBOutlet weak var monthlyincomeVw: UIView!
    
    var defaultBorderColor : CGColor!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        defaultBorderColor = fullnameVw.layer.borderColor
        self.hideKeyboardWhenTappedAround()

    }

    @IBOutlet weak var txtBudget: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtIncome: UITextField!
    
    @IBAction func saveUserInfo(_ sender: Any) {
           
        
 
        //Get users fullname
        let fullname = txtFullname.text!

        //Get users income
        let income = NSDecimalNumber(string: txtIncome.text == "" ? "0" : txtIncome.text)
        let tmp_income = Float(truncating: income)
        
        //Get users budget
        let budget = NSDecimalNumber(string: txtBudget.text == "" ? "0" : txtBudget.text)
        let tmp_budget = Float(truncating: budget)
         
        
        //reset border color
        fullnameVw.layer.borderWidth = 0
        monthlyincomeVw.layer.borderWidth = 0
        budgetVw.layer.borderWidth = 0
        
        if(fullname == ""){
            showMsg(title:"Missing Value",txtField: txtFullname,msg: "Please enter your full name.",errorView: fullnameVw)
           
          
            return
        }else if tmp_income < 1  {
            showMsg(title:"Missing Value",txtField: txtIncome,msg: "Please enter your total monthly income. Income must be greater than 0",errorView: monthlyincomeVw)
            return
        }else if tmp_income.isNaN {
            showMsg(title:"Invalid Input",txtField: txtIncome,msg: "Please enter a valid monthly income. This field allows only numbers and decimal point",errorView: monthlyincomeVw)
            return
        }
        else if (tmp_budget < 1 ){
            showMsg(title:"Missing Value",txtField: txtBudget,msg: "Please enter your total monthly budget. Income must be greater than 0",errorView: budgetVw)
            return
        }
        else if tmp_budget.isNaN {
            showMsg(title:"Invalid Input",txtField: txtBudget,msg: "Please enter a valid monthly budget. This field allows only numbers and decimal point",errorView: budgetVw)
            return
        }
         
        
        
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

        // add budgets to core data
        let budget1 = Expenses(context: getContext())
        budget1.id = UUID()
        budget1.name = "Food"
        budget1.categoryId = category.id
        budget1.categoryName = category.name
        budget1.amount = 600
        let calendar = Calendar.current
        if let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date()){
            budget1.created = lastMonth
        }

        let budget2 = Expenses(context: getContext())
        budget2.id = UUID()
        budget2.name = "Rent"
        budget2.categoryId = category2.id
        budget2.categoryName = category2.name
        budget2.amount = 900
        if let last2Month = calendar.date(byAdding: .month, value: -2, to: Date()){
            budget2.created = last2Month
        }

        
        let budget3 = Expenses(context: getContext())
        budget3.id = UUID()
        budget3.name = "Gas"
        budget3.categoryId = category3.id
        budget3.categoryName = category3.name
        budget3.amount = 800
        if let last3Month = calendar.date(byAdding: .month, value: -3, to: Date()){
            budget3.created = last3Month
        }


        let budget4 = Expenses(context: getContext())
        budget4.id = UUID()
        budget4.name = "Electricity"
        budget4.categoryId = category4.id
        budget4.categoryName = category4.name
        budget4.amount = 500
        if let last4Month = calendar.date(byAdding: .month, value: -4, to: Date()){
            budget4.created = last4Month
        }

        let budget5 = Expenses(context: getContext())
        budget5.id = UUID()
        budget5.name = "Doctor"
        budget5.categoryId = category5.id
        budget5.categoryName = category5.name
        budget5.amount = 300
        if let last5Month = calendar.date(byAdding: .month, value: -5, to: Date()){
            budget5.created = last5Month
        }        

        self.saveAll()
       
        navigateToMainView()
      
 
    }
    
    
    
    
    func navigateToMainView(){
        
        let _: UIViewController? = nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(mainTabBarController  )
    }
    
    
    
    func showMsg(title: String ,txtField : UITextField, msg: String, errorView : UIView )
    {
      
        
        // Create a new alert
        let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        // Present alert to user
        dialogMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
               
                errorView.layer.borderWidth = 1
                errorView.layer.borderColor = UIColor.red.cgColor
                txtField.becomeFirstResponder()
            }
            
              }))
        self.present(dialogMessage, animated: true, completion: nil)
 
       
    }
    
    
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
    
    
    func getUserInfo(){
  
        
        let user_request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest ()
        do {
            let users = try getContext().fetch(user_request)
            
            if(users.count > 0)
            {
                for user in users{
                    UserDefaults().setValue(user.fullName, forKey: "fullame")
                }
  
            }
            

             
        } catch {
            print ("error fetching data: \(error)")
        }
    }
    
    @IBAction func saveCategory(_ sender: Any) {
    }
    
    func saveAll(){
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
         
        //print("Saved")
        //getUserInfo()
        //print("Loaded")

 
    }
    
   
}
 

