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
    
    var data: [BarData] = []
    
    private var categoriesArray : [Categories] = []
    private var groupedCategoryList: [Expenses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.rowHeight = 80
        viewAllButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        
        data.append(BarData.init(barTitle: "Jan", barValue: 1.4, pinText: "140$"))
        data.append(BarData.init(barTitle: "Feb", barValue: 9.0, pinText: "900$"))
        data.append(BarData.init(barTitle: "Mar", barValue: 3.1, pinText: "310$"))
        data.append(BarData.init(barTitle: "Apr", barValue: 4.8, pinText: "480$"))
        data.append(BarData.init(barTitle: "May", barValue: 6.6, pinText: "660$"))
        data.append(BarData.init(barTitle: "Jun", barValue: 7.4, pinText: "740$"))
        data.append(BarData.init(barTitle: "Jul", barValue: 5.5, pinText: "550$"))

        chart.data = data
        chart.barsCanBeClick = true
        chart.maxValue = 10.0
        chart.progressColor =  UIColor(hex: "#FE7685ff")!
        chart.barTitleColor = UIColor(hex: "#212121ff")!
        chart.barTitleSelectedColor = UIColor(hex: "#FE7685ff")!
        chart.barTitleFont = UIFont(name: "Avenir Medium", size: 12)
        chart.pinMarginBottom = 15
        chart.pinWidth = 70
        chart.pinHeight = 29
        chart.pinTxtSize = 17
        chart.delegate = self
        chart.build()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 65

        // Do any additional setup after loading the view.
        loadValues()
    }
    
    @IBAction func onViewAllPressed(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }
    
    func loadValues() {
        
        let cat_request: NSFetchRequest<Categories> = Categories.fetchRequest ()
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
                    totalIncome.text = "$ \(exp.income ?? 0)"
//                    totalBudgetFromCard.text = "$ \(exp.budget ?? 0)"
                }
    
            } catch {
                print ("error fetching data: \(error)")
            }
        
        let request1: NSFetchRequest<Expenses> = Expenses.fetchRequest()
            do {
                let items = try getContext().fetch(request1)
                var uniqueCategory: [Expenses] = []
    
                for item in items{
                    if uniqueCategory.contains(where: { exp in
                        exp.categoryName == item.categoryName
                    }){
                        let index = uniqueCategory.firstIndex { exp in
                            exp.categoryName == item.categoryName
                        }
                        uniqueCategory[index!].amount += item.amount
                    }else{
                        uniqueCategory.append(item)
                    }
                }
                groupedCategoryList = uniqueCategory
                tableView.reloadData()
                
    
            } catch {
                print ("error fetching data: \(error)")
            }
        
//        let keypathExp = NSExpression(forKeyPath: "categoryName") // can be any column
//        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
//        let countDesc = NSExpressionDescription()
//        countDesc.expression = expression
//        countDesc.name = "amount"
//        countDesc.expressionResultType = .integer64AttributeType

            
//        let request1 = NSFetchRequest<NSDictionary>(entityName: "Expenses")
//        request1.returnsObjectsAsFaults = false
//        request1.propertiesToGroupBy = ["categoryName","amount"]
//        request1.propertiesToFetch = ["categoryName","amount"]
//        request1.resultType = .dictionaryResultType
//
//            do {
//                let itemDictionary = try getContext().fetch(request1)
//                print(itemDictionary)
//                for (i,element) in itemDictionary.enumerated(){
//
//                    for (key, value) in element {
//                        items.append(value)
//
//                    }
//
//
//                    print(itemDictionary[i])
//                    items.append(ExpenseStruct(amount: element["amount"], categoryName: element["amount"]))
//                }
//
//                tableView.reloadData()
//
//            } catch {
//                print ("error fetching data: \(error)")
//            }
            
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
        
        let ExpCategoryName = groupedCategoryList[indexPath.row].categoryName!
        
     
        
        let categoryElem  = categoriesArray.first { $0.name! == ExpCategoryName }
        
        cell.categoryImage.image = UIImage(systemName: (categoryElem?.icon)!)
        cell.categoryName.text = groupedCategoryList[indexPath.row].categoryName
        cell.totalPrice.text = "\( String(format: "$%.2f",  groupedCategoryList[indexPath.row].amount ) )"
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
