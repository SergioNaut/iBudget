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
        let cellImg = UIImage(systemName: categoriesArray[indexPath.row].icon!)!.withTintColor(UIColor(hex: "#494949ff")!)
        //(UIColor(hex: "#F7F8FCff")!)
        .resized(to: CGSize(width: 28, height: 24))
        
       // cell.imageView?.image?.withTintColor(.purple).withTintColor(.systemIndigo, renderingMode: .alwaysTemplate)
        cell.imageView?.cornerRadius = 8
        cell.imageView?.image = cellImg//!.withTintColor(.systemIndigo)
        cell.imageView?.backgroundColor =  UIColor(hex: "#F7F8FCff")!
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        cell.imageView?.contentMode = .scaleAspectFit;
      
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



 
