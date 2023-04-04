//
//  CategorySummaryViewController.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 02/04/2023.
//
import Foundation
import Foundation
import UIKit
import CoreData
import Popover
import MonthYearPicker

class CategorySummaryViewController: UIViewController {
 
    private var categoriesArray : [Categories] = []
    private var groupedCategoryList: [ExpenseStruct] = []
    var totalBudget : Double = 0
    var totalExpense : Double = 0
    var monthName = ""
    var yearofMonth = 0
    var monthYear = ""
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var pickerDate = Date()
    var expenses : [Expenses] = []
    var categoryName = ""
    var categoryId = UUID()
    
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMonthSelected: UILabel!
    @IBOutlet weak var lbltotalExpense: UILabel!
    @IBOutlet weak var lblmonthName: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var calendarIcon2: UIImageView!
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
        lblmonthName.text = monthYear
        lbltotalExpense.text = "0.0"//\(String(format: "$%.2f", totalExpense))"
        monthName = Date().monthName()
        yearofMonth = Date().currentYear()
        lblCategoryName.text  = categoryName//.uppercased()
        lblMonthSelected.text = ("\(Date().monthName())  \(yearofMonth)")
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        lblMonthSelected.addGestureRecognizer(guestureRecognizer)
        let guestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        calendarIcon2.addGestureRecognizer(guestureRecognizer2)
        let categoriesLabelguestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCategories(_:)))
        lblCategoryName.addGestureRecognizer(categoriesLabelguestureRecognizer)
        print(categoryId)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
        // Do any additional setup after loading the view.
        loadExpenses(_monthName: monthName, _year: yearofMonth)
    }
    
    @objc func labelClicked(_ sender: Any) {
        let startPoint = CGPoint(x: lblMonthSelected.frame.origin.x+20, y: lblMonthSelected.superview!.frame.origin.y + 58 )
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-50, height: 180))
        let popover = Popover()
        let calendar = Calendar.current
        let currentDate = NSDate()
        let sevenMonthsAgo = calendar.date(byAdding: .month, value: -7, to: currentDate as Date)!
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: 0 / 2), size: CGSize(width: view.bounds.width, height: 216)))
       
        picker.minimumDate = sevenMonthsAgo
        picker.maximumDate = Date().removeTimeStamp
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        picker.setDate(pickerDate, animated: true)
        aView.addSubview(picker)
        popover.show(aView, point: startPoint)
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        
        //let monthName = months[picker.date.monthIndex() > 11 ? 0 :picker.date.monthIndex() ]
        
        let monthIndx =   picker.date.description.split(separator: "-")[1]
        let monthName = months[ Int(monthIndx)! - 1 ]
        
        lblMonthSelected.text =  monthName + " " + String(picker.SelectedYear)
        // currrentMonthName  =  monthName
        loadExpenses(_monthName: monthName, _year: picker.SelectedYear)
        pickerDate = picker.date
        //setTotals()
    }
    
    ///Show Category List
    @objc func showCategories(_ sender: Any) {
        
        let detailViewController = categoryList()
        detailViewController.presenterName = "categorySummary"
        detailViewController.monthName = monthName
        detailViewController.yearSelected = yearofMonth
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(nav, animated: true, completion: nil)
    }
    
    func loadExpenses(_monthName: String, _year : Int) {
        expenses = []
        lbltotalExpense.text = "$ 0.0"
        lblCategoryName.text = lblCategoryName.text?.glazeCamelCase
        tableView.reloadData()
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
            let result = exps.filter( {$0.categoryId == categoryId} )
            self.totalExpense = result.reduce(0, {$0 + $1.amount})
            lbltotalExpense.countAnimation(upto: totalExpense)
            expenses.append(contentsOf: result )
            tableView.reloadData()
            
        } catch {
            print ("error fetching data: \(error)")
        }
       // setTotals()
    }
    
    
    func CurrentYear()->Int  {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: date)) ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;//Choose your custom row height
    }
     
}


extension CategorySummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(expenses.count)
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell

        let expenseObj = expenses[indexPath.row]
        let formatter = NumberFormatter()
        let currPrice = Double(truncating: expenseObj.amount as NSNumber)
        let progressValue = Double(currPrice)
        let catPercent =  round(Float(progressValue) / Float(totalExpense)*100)
        let expenseProgressBar = cell.viewWithTag(4001) as! UIProgressView
        let expensedate = cell.viewWithTag(1009) as! UILabel
        expensedate.text = expenseObj.created?.customfullDate()
        cell.categoryName.text = expenseObj.name
        formatter.minimumFractionDigits = 2
        cell.totalPrice.text = "$\(progressValue.abbreviateNumber()) (\(catPercent)%)"
        expenseProgressBar.setProgress(0.0, animated: false) // Set initial progress value to 0
         
        if(progressValue > totalBudget) {
            expenseProgressBar.progressTintColor = .systemBlue
        } else {
            expenseProgressBar.progressTintColor = .systemTeal
        }
        expenseProgressBar.setProgress(Float(progressValue) / Float(totalExpense), animated: true) // Set maximum progress value
        
        return cell
    }

}
extension CategorySummaryViewController: UITableViewDelegate {
    
}


 
