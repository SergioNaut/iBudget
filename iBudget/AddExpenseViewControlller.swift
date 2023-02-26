//
//  addexpenses.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 03/02/2023.
//

import Foundation
import UIKit
import CoreData
import LinkPresentation

class AddExpenseViewControlller : UIViewController {
    
     
    
    
    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var expenseCategory: UITextField!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var isEdit: Bool = false
    var editExpenseItem: Expenses!
    
    @IBOutlet weak var CategoryVW: UIView!

    @IBOutlet weak var expensenameVW: UIView!
    @IBOutlet weak var amountVW: UIView!
    
    var categorySelected : Categories!
    
    override func viewDidLoad() {
        //presentModal()
        self.hideKeyboardWhenTappedAround()
        if(isEdit){
            titleText.text="Edit Expense"
            saveButton.setTitle("Edit", for: .normal)
            expenseName.text = editExpenseItem.name
            expenseAmount.text = ("\(editExpenseItem.amount)")
            expenseCategory.text = editExpenseItem.categoryName
            getCategoryData()
        }
    }
    
    func getCategoryData(){
        let request: NSFetchRequest<Categories> = Categories.fetchRequest ()
        do {
            let categories = try getContext().fetch(request)
            var categoriesArray: [Categories] = []
            for category in categories{
                categoriesArray.append(category)
            }
            if let index = categoriesArray.firstIndex(where: { $0.id == editExpenseItem.categoryId }) {
                categorySelected = categoriesArray[index]
            }
        } catch {
            print ("error fetching data: \(error)")
        }
    }
    
    @IBAction func startEdit(_ sender: Any) {
       resignFirstResponder()
        let detailViewController = categoryList() 
        let nav = UINavigationController(rootViewController: detailViewController)
        
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false

        }
        
        present(nav, animated: true, completion: nil)
    }
    
    
    
    func getContext()->NSManagedObjectContext {
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        return context
    }
    
    func addExpense() {
        let exp = Expenses(context: getContext())
        let id = UUID()
        exp.id = id
        exp.name = expenseName.text?.glazeCamelCase
        exp.categoryId = categorySelected.id
        exp.categoryName = categorySelected.name
        exp.amount = Double(  expenseAmount.text! ) ?? 0
        exp.created = Date()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        dismiss(animated: true)
    }
    
    
    
    
    func validateData() {
         
        expensenameVW.layer.borderWidth = 0
        CategoryVW.layer.borderWidth = 0
        expensenameVW.layer.borderWidth = 0
        
        
        //Get users expense amount
        let exp_amount = NSDecimalNumber(string: expenseAmount.text == "" ? "0" : expenseAmount.text)
        let tmp_amount = Float(truncating: exp_amount)
        
        if(!expenseCategory.hasText )
        {
            showMsg(title:"Missing Value",txtField: expenseCategory,msg: "Please select the category for this expense",errorView: CategoryVW)
            return
        }else if(!expenseName.hasText )
        {
            showMsg(title:"Missing Value",txtField: expenseName,msg: "Please enter a name for this expense",errorView: expensenameVW)
            return
        }else if(!expenseAmount.hasText )
        {
            showMsg(title:"Missing Value",txtField: expenseAmount,msg: "Please enter the total amount for this expense",errorView: amountVW)
            return
        }else if tmp_amount < 1  {
            showMsg(title:"Invalid Input ",txtField: expenseAmount,msg: "Expense amount must be greater than 0 ",errorView: amountVW)
            return
        }else if tmp_amount.isNaN {
            showMsg(title:"Invalid Input",txtField: expenseAmount,msg: "Please enter a valid expense. This field allows only numbers and decimal point",errorView: amountVW)
            return
        }
        
        
        
//        let alert = UIAlertController(title: "Validation", message: "You need to fill in the category, title and amount to submit.", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        return;
        
       // || !expenseAmount.hasText || !expenseCategory.hasText
        
        
        
        if(isEdit){
            editExpense()
        }else {
            addExpense()
        }
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
               
                
                if(txtField != self.expenseCategory) {
                    txtField.becomeFirstResponder()
                }else{
                    txtField.becomeFirstResponder()
                    self.view.endEditing(true)
                    //self.dismissKeyboard()
                }
                
            }
            
              }))
        self.present(dialogMessage, animated: true, completion: nil)
 
       
    }
    
    
    
    
    func editExpense(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
        fetchRequest.predicate = NSPredicate(format: "id == %@", editExpenseItem.id!.description as String)

        do {
            let results = try getContext().fetch(fetchRequest)
            if let editedExpense = results.first as? Expenses {
                editedExpense.name = expenseName.text?.glazeCamelCase
                editedExpense.categoryId = categorySelected.id
                editedExpense.categoryName = categorySelected.name
                editedExpense.amount = Double(  expenseAmount.text! ) ?? 0
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                dismiss(animated: true)
            }
        } catch {
            print("Error updating object: \(error)")
        }
    }
    
    
    @IBAction func closeForm(_ sender: Any) {
        dismiss(animated: true)
    }
    
  
    
    
    @IBAction func saveExpense(_ sender: Any) {
        validateData()
    }
    
    @IBAction func showCategoryList(_ sender: Any) {
        presentModal()
    }
    private func presentModal() {
      

    }
     
}


extension AddExpenseViewControlller  {
    
    func showSelectedCategory(_category: Categories) {
        expenseCategory.text = _category.name
    }
}

 

