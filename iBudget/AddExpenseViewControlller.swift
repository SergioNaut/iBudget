//
//  addexpenses.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 03/02/2023.
//

import Foundation
import UIKit
import CoreData

class AddExpenseViewControlller : UIViewController{

    
    
    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var expenseCategory: UITextField!
    
    var categorySelected : Categories!
    
    override func viewDidLoad() {
        //presentModal()
        self.hideKeyboardWhenTappedAround()

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
                
        if(!expenseName.hasText || !expenseAmount.hasText || !expenseCategory.hasText)
        {
            let alert = UIAlertController(title: "Validation", message: "You need to fill in the category, title and amount to submit.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        
            return;
        }
        
        
        let exp = Expenses(context: getContext())
        exp.name = expenseName.text
        exp.categoryId = categorySelected.id
        exp.categoryName = categorySelected.name
        exp.amount = Double(  expenseAmount.text! ) ?? 0
        exp.created = Date()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        dismiss(animated: true)
    }
    
    
    @IBAction func closeForm(_ sender: Any) {
        dismiss(animated: true)
    }
    
  
    
    
    @IBAction func saveExpense(_ sender: Any) {
        
        addExpense()
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

