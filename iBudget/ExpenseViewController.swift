//
//  ExpenseViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-01-31.
//

import Foundation
import UIKit
import CoreData
import LinkPresentation

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var expenses : [Expenses] = []
    private var categoriesArray: [Categories] = []
    var isEdit: Bool = false
    var selectedExpense: Expenses!
    
    @IBOutlet weak var lblExpenseSubtitle: UILabel!
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
        self.hideKeyboardWhenTappedAround()
      
        lblExpenseSubtitle.text = "All expenses for " + ("").getCurrentShortMonth
        
    }
    
    //load the view each time we are at this screen
    override func viewDidAppear(_ animated: Bool) {
        loadExpenses()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExpense" {
            let destinationVC = segue.destination as? AddExpenseViewControlller
            destinationVC?.isEdit = isEdit
            destinationVC?.editExpenseItem = selectedExpense
        }
    }
    
    
    //get connection
    func getContext()->NSManagedObjectContext{
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        return context
    }
    
    func loadExpenses() {
        expenses = []
        let ExpRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest ()
        let request: NSFetchRequest<Categories> = Categories.fetchRequest ()
        do {
            let exps = try getContext().fetch(ExpRequest)
            expenses.append(contentsOf: exps)
            
           
            
            tableView.reloadData()
            
        } catch {
            print ("error fetching data: \(error)")
        }
        
        do{
            let categories = try getContext().fetch(request)
            categoriesArray.append(contentsOf: categories)
        }
             catch {
                print ("error fetching data: \(error)")
            }
    }
    
    func deleteExpenses(contextIndx : Int) {
         getContext().delete(expenses[contextIndx])
    }
    
    func shareExpense(expenseRecord: Expenses)
    {
        
        let title = "IBudget (Share Expense)"
        //let text = "Some Text"
     
        
        
        let text = "Hello \(UserDefaults().string(forKey: "fullname")!) is sharing this expense with  you: "
        
        
        let expenseDetails = "\(expenseRecord.name ?? "") $\(expenseRecord.amount)"
        
        // set up activity view controller
        let textToShare: [Any] = [
            MyActivityItemSource(title: title, text: text + expenseDetails)
        ]
       
        
        
        
        //let objectsToShare: [Any] = [textToShare, expenseDetails]
        
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        //let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.title = "Share Expense"
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.barButtonItem?.title  = "Share Expense" 
        self.present(activityVC, animated: true, completion: nil)
        
    }
}


extension ExpenseViewController: UITableViewDelegate {
}

extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
    
        let  ExpCategoryName = expenses[indexPath.row].categoryName
        let categoryElem  = categoriesArray.first { $0.name! == ExpCategoryName }
        
        cell.categoryImage.image = UIImage(systemName: categoryElem!.icon!)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E MMM d, YYYY"
        
        let date = dateFormatterGet.string(from: expenses[indexPath.row].created!)
        
        cell.createdTimeStamp.text = date //+ (expenses[indexPath.row].created?.formatted())!
        cell.categoryName.text = expenses[indexPath.row].name
        cell.totalPrice.text = "\( String(format: "$%.2f",  expenses[indexPath.row].amount ) )"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view,actionPerformed:
        (Bool) -> ()) in
            self.isEdit = true
            self.selectedExpense = self.expenses[indexPath.row]
            self.performSegue(withIdentifier: "addExpense", sender: nil)
            self.isEdit = false
            actionPerformed(true)
        }
        edit.backgroundColor = .systemTeal
        
        // share action
        let share = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            self!.shareExpense(expenseRecord:self!.expenses[indexPath.row])
            completionHandler(true)
        }
        share.backgroundColor = .systemGreen
        
        
        
        return UISwipeActionsConfiguration(actions: [edit,share])
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              
              
              let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this expense?", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
                  self.deleteExpenses(contextIndx: indexPath.row)
                  self.expenses.remove(at: indexPath.row)
                  AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                  tableView.deleteRows(at: [indexPath], with: .fade)
              }))
              
              alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Ignore"), style: .cancel, handler: { _ in
                
              }))
              self.present(alert, animated: true, completion: nil)
          }
      }
}

 

class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(named: "logo")!)
        //This is a bit ugly, though I could not find other ways to show text content below title.
      
        metadata.url = URL(fileURLWithPath: text)
        return metadata
    }

}
