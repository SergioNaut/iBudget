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
        lbltotalExpense.countAnimation(upto: totalExpense)
        monthName = Date().monthName()
        yearofMonth = Date().currentYear()
        lblCategoryName.text  = categoryName.uppercased()
        lblMonthSelected.text = ("\(Date().monthName())  \(yearofMonth)")
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        lblMonthSelected.addGestureRecognizer(guestureRecognizer)
        let guestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        calendarIcon2.addGestureRecognizer(guestureRecognizer2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65
        // Do any additional setup after loading the view.
        loadValues(_monthName: monthName, _year: yearofMonth)
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
        
        let monthName = months[picker.date.monthIndex() > 11 ? 0 :picker.date.monthIndex() ]
        lblMonthSelected.text =  monthName + " " + String(picker.SelectedYear)
        // currrentMonthName  =  monthName
        loadExpenses(_monthName: monthName, _year: picker.SelectedYear)
        pickerDate = picker.date
        //setTotals()
    }
    
    func loadExpenses(_monthName: String, _year : Int) {
        expenses = []
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
            //check if its equal to category selected
            expenses.append(contentsOf: exps)
            
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
    
    
    func loadValues( _monthName: String, _year : Int) {
        
        categoriesArray = []
        groupedCategoryList = []
       
        let cat_request: NSFetchRequest<Categories> = Categories.fetchRequest()
        do{
            let categories = try getContext().fetch(cat_request)
            categoriesArray.append(contentsOf: categories)
        }
        catch {
            print ("error fetching data: \(error)")
        }
        
        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest ()
            do {
                let exps = try getContext().fetch(request)
    
                for exp in exps{
                    totalBudget = exp.budget as! Double
                }
    
            } catch {
                print ("error fetching data: \(error)")
            }
        
        
        
        let fetchRequestFilteredByMonth = NSFetchRequest<Expenses>(entityName: "Expenses")
        
        // Get the current calendar and the desired month and year
        let monthName = _monthName == "" ?  String().getCurrentLongMonthName : _monthName
        let calendar = Calendar.current
        guard let month = DateFormatter().monthSymbols.firstIndex(of: monthName) else {
            print("Invalid month name: \(monthName)")
            return
        }
        
        let year = _year == 0 ?  CurrentYear() : _year
        // Create a date range for the desired month and year
        let startDateComponents = DateComponents(year: year, month: month + 1, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!

        // Create a predicate that checks if the "created" field of the expense is between the start and end dates of the desired month and year
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", startDate as NSDate, endDate as NSDate)
        
        // Set the predicate on the fetch request
        fetchRequestFilteredByMonth.predicate = predicate
         
            do {
                let items = try getContext().fetch(fetchRequestFilteredByMonth)
                var categoryAmounts = [String: Double]()

                for item in items {
                    
                    //totalExpense +=   item.amount
                    
                    if let currentAmount = categoryAmounts[item.categoryName!] {
                        categoryAmounts[item.categoryName!] = currentAmount + item.amount
                        
                       
                        
                    } else {
                        categoryAmounts[item.categoryName!] = item.amount
                    }
                }

                groupedCategoryList = categoryAmounts.map { ExpenseStruct(amount: Decimal($0.value), categoryName: $0.key) }
                tableView.reloadData()
                 
            } catch {
                print ("error fetching data: \(error)")
            }
    }
    
    func getContext()->NSManagedObjectContext {
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    
}


extension CategorySummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
        
        let ExpCategoryName = groupedCategoryList[indexPath.row].categoryName
        
     
        
        let categoryElem  = categoriesArray.first { $0.name! == ExpCategoryName }
        
        cell.categoryImage.image = UIImage(systemName: (categoryElem?.icon)!)
        cell.categoryName.text = groupedCategoryList[indexPath.row].categoryName
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let currPrice = Double(truncating: groupedCategoryList[indexPath.row].amount as NSDecimalNumber)
       // let total =  totalExpense
        let progressValue = Double(currPrice)

        //if let formattedString = formatter.string(from: groupedCategoryList[indexPath.row].amount as NSDecimalNumber) {
           // print("Percentage price: \(currPrice) total expense: \(totalExpense)")
        
            let catPercent =  round(Float(progressValue) / Float(totalExpense)*100)
            cell.totalPrice.text = "$\(progressValue.abbreviateNumber()) (\(catPercent)%)"
        //}
        
        let expenseProgressBar = cell.viewWithTag(4001) as! UIProgressView
        expenseProgressBar.setProgress(0.0, animated: false) // Set initial progress value to 0
         
        if(progressValue > totalBudget) {
            expenseProgressBar.progressTintColor = .red
        } else {
            expenseProgressBar.progressTintColor = .systemTeal
        }
        //let progressValue = total > totalBudget ? totalBudget: total
       // print(Float(progressValue) / Float(totalExpense))
        expenseProgressBar.setProgress(Float(progressValue) / Float(totalExpense), animated: true) // Set maximum progress value
        
        return cell
    }

}
extension CategorySummaryViewController: UITableViewDelegate {
    
}


 