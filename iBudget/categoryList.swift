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
    
    
    override func viewDidLoad() {
        loadValues()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Select Category"
        tableView.reloadData()
        tableView.separatorStyle = .none
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
        let cellImg = UIImage(systemName: categoriesArray[indexPath.row].icon!)?.resized(to: CGSize(width: 34, height: 34))
        cell.imageView?.contentMode = .scaleAspectFit;
        cell.imageView?.image = cellImg
        cell.imageView?.image = cell.imageView?.image?.withTintColor(UIColor.systemIndigo)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
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
