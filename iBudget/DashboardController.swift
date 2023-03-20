//
//  DashboardController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-01-21.
//

import Foundation
import UIKit
import CoreData
import ChartProgressBar



class DashboardViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalBudget: UILabel!
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var remainingBudget: UILabel!
    @IBOutlet weak var totalBudgetFromCard: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: ChartProgressBar!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var last7MonthWindow: UILabel!
    
    @IBOutlet weak var totalBudgetlabel: UILabel!
    @IBOutlet weak var lblCurrentMonthTotalExpenselabel: UILabel!
    var data: [BarData] = []
    var last7Months: [MonthYear] = []
    var totalSavedBuget: Double = 0
    
    private var categoriesArray : [Categories] = []
    private var groupedCategoryList: [ExpenseStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCurrentMonthTotalExpenselabel.text =  "Total Expenses " + "(" + ("").getCurrentShortMonth + ")"
       
        totalBudgetlabel.text = "Total Budget " + "(" + ("").getCurrentShortMonth + ")"
        tableView.rowHeight = 60
        viewAllButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
    }

    func getLast7Months() {
        last7Months = []
        let calendar = Calendar.current
            let now = Date()
            let startOfToday = calendar.startOfDay(for: now)
            for i in 0..<7 {
                let date = calendar.date(byAdding: .month, value: -i, to: startOfToday)!
                let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
                let year = calendar.component(.year, from: date)
                let monthYear = MonthYear(month: monthName, year: year)
                last7Months.append(monthYear)
            }
        setBarChart()
        print(last7Months)
        print(
            getTotalAmountForMonth(last7Months[1].month, year: last7Months[1].year)!
        )
    }
    
    func setBarChart(){
        var greatestExpense = 0.0
        var disabledMonths : [Int] = []
        data = []
        last7Months.reverse()        
        for month in last7Months {
            let totalAmount = getTotalAmountForMonth(month.month, year: month.year) ?? 0
            if greatestExpense < totalAmount {
                greatestExpense = totalAmount
            }
            let monthName = String(month.month.prefix(3))
            if(totalAmount > 0){
                data.append(BarData.init(barTitle: monthName, barValue: Float(totalAmount/100), pinText: "$ \(String(format: "%.2f", totalAmount))"))
            }else{
                disabledMonths.append(last7Months.firstIndex(of: month)!)
                data.append(BarData.init(barTitle: monthName, barValue: 0.0, pinText: "$0"))
            }
        }
        
        
        
        
        chart.data = data
//        chart.barsCanBeClick = true
        chart.maxValue = Float( totalSavedBuget / 100 )
        chart.progressColor =  UIColor(hex: "#FE7685ff")!
        chart.barTitleColor = UIColor(hex: "#212121ff")!
        chart.barTitleSelectedColor = UIColor(hex: "#FE7685ff")!
        chart.barTitleFont = UIFont(name: "Avenir Book", size: 12)
        chart.pinMarginBottom = 15
        chart.pinMarginTop = 50
        chart.pinWidth = 70
        chart.pinHeight = 29
        chart.pinTxtSize = 14
        chart.delegate = self
        chart.build()
        setTotalExpenseAndCalendar()
    }
    
    func setTotalExpenseAndCalendar(){
        
        totalIncome.text = data.last?.pinText
        
        UserDefaults(suiteName:"com.group8.iBudget.ibudgetedWidget")!.set(totalIncome.text, forKey: "totalExpense")
        UserDefaults(suiteName:"com.group8.iBudget.ibudgetedWidget")!.set(totalBudget.text, forKey: "Budget")
        
        
        let lastDay = getLastDayOfMonth(monthName: last7Months.last!.month) ?? 0
        last7MonthWindow.text = "01 \(last7Months.first?.month.prefix(3) ?? "") - \(lastDay) \(last7Months.last?.month.prefix(3) ?? "")"
    }
    
    func getLastDayOfMonth(monthName: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        guard let monthDate = dateFormatter.date(from: monthName) else {
            return nil
        }
        
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthDate)!
        let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
        let day = calendar.component(.day, from: lastDayOfMonth)
        return day
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
            return totalAmount
        } catch {
            print("Error fetching expenses: \(error)")
            return nil
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65

        // Do any additional setup after loading the view.
        loadValues()
        getLast7Months()
        chart.removeClickedBar()
    }
    
    @IBAction func onViewAllPressed(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;//Choose your custom row height
    }
    
    func loadValues() {
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
                    userName.text = "Hi, \(exp.fullName ?? "-")"
                    totalBudget.text = "$ \(exp.budget ?? 0)"
                    totalSavedBuget = exp.budget as! Double
                }
    
            } catch {
                print ("error fetching data: \(error)")
            }
        
        let request1: NSFetchRequest<Expenses> = Expenses.fetchRequest()
            do {
                let items = try getContext().fetch(request1)
                var categoryAmounts = [String: Double]()

                for item in items {
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
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    
}

extension DashboardViewController: UITableViewDataSource {
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

        if let formattedString = formatter.string(from: groupedCategoryList[indexPath.row].amount as NSDecimalNumber) {
            cell.totalPrice.text = "$\(formattedString)"
        }
        return cell
    }

}

extension DashboardViewController: UITableViewDelegate {
    
}

extension DashboardViewController: ChartProgressBarDelegate {
    func ChartProgressBar(_ chartProgressBar: ChartProgressBar, didSelectRowAt rowIndex: Int) {
        print(rowIndex)
    }
}

struct ExpenseStruct {
    let amount: Decimal
    let categoryName: String
    
    init(amount: Decimal, categoryName: String) {
        self.amount = amount
        self.categoryName = categoryName
    }
}

struct MonthYear: Equatable {
    let month: String
    let year: Int
}
