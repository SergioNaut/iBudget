//
//  categoriesDetailViewController.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 04/02/2023.
//

import Foundation
import UIKit
import CoreData
 

class categoryList : UITableViewController  {
    private var categoriesArray: [Categories] = []
    public var presenterName = ""
    public var monthName = ""
    public var yearSelected = 0
    override func viewDidLoad() {
        loadValues()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Select Category"
        tableView.reloadData()
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
    }
    
    func loadValues() {
        
        let request: NSFetchRequest<Categories> = Categories.fetchRequest ()
        do {
            let categories = try getContext().fetch(request)
           
            for category in categories{
                categoriesArray.append(category)
            }
            
        } catch {
            print ("error fetching data: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    
  
     
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let containerView = UIView(frame: CGRect(x: 15, y: 9, width: 42, height: 40))
        containerView.backgroundColor = UIColor(hex: "#F7F8FCff")
//        containerView.cornerRadius = 8

        let imageView = UIImageView(frame: CGRect(x: 6, y: 2, width: 30, height: 37))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: categoriesArray[indexPath.row].icon!)!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(weight: .light))
        
        imageView.tintColor = UIColor(hex: "#494949ff")
        
        containerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 72, y: 8, width: 255, height: 40))
        label.text = categoriesArray[indexPath.row].name
        cell.addSubview(label)
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        cell.addSubview(containerView)
     
//        let cellImg = UIImage(systemName: categoriesArray[indexPath.row].icon!)!.withTintColor(UIColor(hex: "#494949ff")!)
//        //(UIColor(hex: "#F7F8FCff")!)
//            .resized(to: CGSize(width: 37, height: 30))
//        cell.imageView?.contentMode = .scaleAspectFit;
//       // cell.imageView?.image?.withTintColor(.purple).withTintColor(.systemIndigo, renderingMode: .alwaysTemplate)
//        cell.imageView?.cornerRadius = 8
//        cell.imageView?.image = cellImg//!.withTintColor(.systemIndigo)
//        cell.imageView?.backgroundColor =  UIColor(hex: "#F7F8FCff")!
//        cell.imageView?.
//        cell.textLabel?.text = categoriesArray[indexPath.row].name
       
      
        return cell
    }
    
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if(presenterName == "categorySummary") {
            if  let presenter = presentingViewController as? CategorySummaryViewController {
                presenter.categoryId = categoriesArray[indexPath.row].id ?? UUID()
                presenter.lblCategoryName.text = categoriesArray[indexPath.row].name?.glazeCamelCase ?? "not found"
                presenter.loadExpenses(_monthName: monthName, _year: yearSelected)
                dismiss(animated: true)
            }
        }
        
        if let presenter = presentingViewController as? AddExpenseViewControlller {
            presenter.categorySelected = categoriesArray[indexPath.row]
            presenter.showSelectedCategory(_category: categoriesArray[indexPath.row])
        }
       
        dismiss(animated: true)
    }
    
    func getContext()->NSManagedObjectContext{
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        return context
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
}



 
