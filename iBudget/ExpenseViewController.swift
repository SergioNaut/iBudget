//
//  ExpenseViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-01-31.
//

import Foundation
import UIKit
import CoreData

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var expenses : [Expenses] = []
    private var categoriesArray: [Categories] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
    }
    
    //load the view each time we are at this screen
    override func viewDidAppear(_ animated: Bool) {
        loadExpenses()
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
    
}


extension ExpenseViewController: UITableViewDelegate {
}

extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
        cell.categoryImage.image = UIImage(systemName: categoriesArray[indexPath.row].icon!)
        
        cell.categoryName.text = expenses[indexPath.row].name
        cell.totalPrice.text = "\( String(format: "$%.2f",  expenses[indexPath.row].amount ) )"
        return cell
    }

}

 
