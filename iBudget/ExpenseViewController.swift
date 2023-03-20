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
import Popover
import MonthYearPicker

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var expenses : [Expenses] = []
    var expensesSearch : [Expenses] = []
    private var categoriesArray: [Categories] = []
    var isEdit: Bool = false
    var selectedExpense: Expenses!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let years = Array(1900...2100).map { String($0) }
    var selectedMonth: String?
    var selectedYear: String?
    let expiryDatePicker = MonthYearWheelPicker()
    var currentTotalExpense = 0.0
    var currrentMonthName = ""
    @IBOutlet weak var expenseFilter: UITextField!
    @IBOutlet weak var expenseProgressBar: UIProgressView!
    
    @IBOutlet weak var lblMonthSelected: UILabel!
    @IBOutlet weak var lblExpenseTotal: UILabel!
    @IBOutlet weak var lblExpenseSubtitle: UILabel!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
        self.hideKeyboardWhenTappedAround()
        lblMonthSelected.text =   String().getCurrentLongMonthName + " " + String(CurrentYear())
        currrentMonthName = String().getCurrentLongMonthName
        selectedMonth = String().getCurrentLongMonthName
        lblMonthSelected.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        lblMonthSelected.addGestureRecognizer(guestureRecognizer)
        lblExpenseTotal.text =  String(getTotalAmountForMonth(("").getCurrentLongMonthName,year: CurrentYear()) ?? 0.0)
    }
    
    var pickerDate = Date()
    
    @objc func labelClicked(_ sender: Any) {
        let startPoint = CGPoint(x: lblMonthSelected.frame.origin.x+20, y: lblMonthSelected.superview!.frame.origin.y + 58 )
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-50, height: 180))
        let popover = Popover()
        let calendar = Calendar.current
        let currentDate = Date()
        let sevenMonthsAgo = calendar.date(byAdding: .month, value: -7, to: currentDate)!
      
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: 0 / 2), size: CGSize(width: view.bounds.width, height: 216)))
             picker.minimumDate = sevenMonthsAgo
             picker.maximumDate = Date()
             picker.setDate(pickerDate, animated: true)
             picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
             
        aView.addSubview(picker)
        popover.show(aView, point: startPoint)
    }
    
    
    
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
         
        let monthName = months[picker.date.monthIndex() - 1]
        lblMonthSelected.text =  monthName + " " + picker.date.Year()
        currrentMonthName  =  monthName
        let selectedYear = Int(picker.date.Year()) ?? 0
        loadExpenses(_monthName: monthName, _year: selectedYear)
        pickerDate = picker.date
        setTotals()
    }
    
    func showPopOverCalendar() {
        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))
        let popover = Popover()
        popover.show(aView, point: startPoint)
    }
    
    @IBAction func viewSummaryScreen(_ sender: Any) {
        let sender : [String: Any?] = ["monthName": currrentMonthName ,"totalExpense": lblExpenseTotal.text,"monthYear":lblMonthSelected.text]
        self.performSegue(withIdentifier: "expSummary", sender: sender)
    }
    
    
 
    @IBAction func filterExpenses(_ sender: UITextField) {
          
        guard let searchText = sender.text  else {return }
        filterContentForSearchText(searchText:  searchText )
    }
    
    func setTotals() {
        
        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest ()
            do {
                let exps = try getContext().fetch(request)
                for exp in exps{
                    totalBudget  =  exp.budget as! Double
                 }
            } catch {
                print ("error fetching data: \(error)")
            }

        
        // let progressBar = UIProgressView(progressViewStyle: .default)
        expenseProgressBar.setProgress(0.0, animated: false) // Set initial progress value to 0
       
        
        let total =  getTotalAmountForMonth(currrentMonthName,year: CurrentYear()) ?? 0.0
        let maxValue = Float(totalBudget)
        
        
        if(total > totalBudget) {
            expenseProgressBar.progressTintColor = .red
        } else {
            
            expenseProgressBar.progressTintColor = .systemTeal
        }
        
        
        let progressValue = total > totalBudget ? totalBudget: total
        
        expenseProgressBar.setProgress(Float(progressValue) / maxValue, animated: true) // Set maximum progress value
        currentTotalExpense = total
        lblExpenseTotal.text = "$\(total.abbreviateNumber())"
        lblExpenseTotal.countAnimation(upto: total)

        
    }
    
    var totalBudget = 0.0
     
    //load the view each time we are at this screen
    override func viewDidAppear(_ animated: Bool) {
        loadExpenses(_monthName:  currrentMonthName, _year: Date().currentYear())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExpenses" {
            let destinationVC = segue.destination as? AddExpenseViewControlller
            destinationVC?.isEdit = isEdit
            destinationVC?.editExpenseItem = selectedExpense
        }else if (segue.identifier == "expSummary") {
            let secondView = segue.destination as! SummaryViewController
            let object = sender as! [String: Any?]
             secondView.monthName =  object["monthName"] as? String ?? ""
             secondView.yearofMonth = object["year"] as? Int ?? CurrentYear()
             secondView.monthYear = object["monthYear"] as? String ?? ""
             secondView.totalExpense = currentTotalExpense
         }
    }
    func CurrentYear()->Int
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: date)) ?? 0
    }
    
    
    //get connection
    func getContext()->NSManagedObjectContext{
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        return context
    }
    
    func getTotalAmountForMonth(_ monthName: String, year: Int) -> Double? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")

        // Get the current calendar and the desired month and year
        let calendar = Calendar.current
        guard let month = DateFormatter().monthSymbols.firstIndex(of: monthName) else {
            print("Invalid month name: \(monthName)")
            return nil
        }

        // Create a date range for the desired month and year
        let startDateComponents = DateComponents(year: year, month: month + 1, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!

        // Create a predicate that checks if the "created" field of the expense is between the start and end dates of the desired month and year
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", startDate as NSDate, endDate as NSDate)

        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate

        do {
            let objects = try getContext().fetch(fetchRequest)
            let totalAmount = objects.compactMap { $0 as? NSManagedObject }
                .compactMap { $0.value(forKey: "amount") as? Double }
                .reduce(0, +)
            print(totalAmount)
            return totalAmount
        } catch {
            print("Error fetching expenses: \(error)")
            return nil
        }
        
      
    }
    
    func loadExpenses(_monthName: String, _year : Int) {
        expenses = []
        expensesSearch = []
        //let ExpRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest ()
        let request: NSFetchRequest<Categories> = Categories.fetchRequest ()
        let fetchRequest = NSFetchRequest<Expenses>(entityName: "Expenses")

        // Get the current calendar and the desired month and year
        let monthName = _monthName == "" ?  String().getCurrentLongMonthName : _monthName
        let calendar = Calendar.current
        guard let month = DateFormatter().monthSymbols.firstIndex(of: monthName) else {
            print("Invalid month name: \(monthName)")
            return
        }
        
        let year = _year == 0 ? CurrentYear() : _year
        // Create a date range for the desired month and year
        let startDateComponents = DateComponents(year: year, month: month + 1, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!

        // Create a predicate that checks if the "created" field of the expense is between the start and end dates of the desired month and year
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", startDate as NSDate, endDate as NSDate)

        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate

        
        do {
            let exps = try getContext().fetch(fetchRequest)
            expenses.append(contentsOf: exps)
            expensesSearch.append(contentsOf: exps)
            tableView.reloadData()
            
        } catch {
            print ("error fetching data: \(error)")
        }
        
        do{
            let categories = try getContext().fetch(request)
            categoriesArray.append(contentsOf: categories)
        } catch {
                print ("error fetching data: \(error)")
        }
        
        setTotals()
    }
    
    func deleteExpenses(contextIndx : Int) {
         getContext().delete(expenses[contextIndx])
         setTotals()
    }
    
    func filterContentForSearchText(searchText: String) {
        
        if(searchText == "") {
             expenses = expensesSearch
        }else{
            expenses = expensesSearch .filter { $0.name!.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
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
            self.performSegue(withIdentifier: "addExpenses", sender: nil)
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
