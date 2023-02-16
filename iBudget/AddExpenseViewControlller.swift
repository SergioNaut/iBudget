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
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var isEdit: Bool = false
    var editExpenseItem: Expenses!
    
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
        exp.name = expenseName.text
        exp.categoryId = categorySelected.id
        exp.categoryName = categorySelected.name
        exp.amount = Double(  expenseAmount.text! ) ?? 0
        exp.created = Date()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        dismiss(animated: true)
    }
    
    func validateData() {
        if(!expenseName.hasText || !expenseAmount.hasText || !expenseCategory.hasText)
        {
            let alert = UIAlertController(title: "Validation", message: "You need to fill in the category, title and amount to submit.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        
            return;
        }
        if(isEdit){
            editExpense()
        }else {
            addExpense()
        }
    }
    
    func editExpense(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
        fetchRequest.predicate = NSPredicate(format: "id == %@", editExpenseItem.id!.description as String)

        do {
            let results = try getContext().fetch(fetchRequest)
            if let editedExpense = results.first as? Expenses {
                editedExpense.name = expenseName.text
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

