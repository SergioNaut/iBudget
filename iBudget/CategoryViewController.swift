//
//  CategoryViewController.swift
//  iBudget
//
//  Created by Pratik Gurung on 2023-01-31.
//

import Foundation
import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    private var categoriesArray: [Categories] = []
    private let addCategorySegue = "addCategoryScreen"
    
    //var newCategory = CategoryValues.init(name: "newCategory", iconName: "sparkle")
    
    @IBAction func addCategoryButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: addCategorySegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        categoriesTableView.dataSource = self
        
        //Uncomment later when categories need to be clickable
        //categoriesTableView.delegate = self
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    func saveAll(){
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
         
        print("Saved")
        //getUserInfo()
        print("Loaded")

    }

    func loadCategories(){
        //TODO: Use to load original categories for the first time
        if(categoriesArray.isEmpty)
        {
            let category = Categories(context: getContext())
            category.name = "Food"
            //Set type as 0 because they are the predefined categories
            category.type = 0
            var id = UUID()
            category.id = id
            //TODO: Change icons
            category.icon = "cloud"
            categoriesArray.append(category)
        //TODO: Add more values
        //TODO: Save to system
        }
    }
    
    public func saveCategory(newCategoryName: String, newCategoryIconName: String){
        let category = Categories(context: getContext())
        category.name = newCategoryName
        category.type = 1
        var id = UUID()
        category.id = id
        category.icon = newCategoryIconName
        categoriesArray.append(category)
        //TODO: Save to system
        categoriesTableView.reloadData()
    }
}

struct CategoryValues {
    let name: String
    let iconName: String
}

//Extension for TableView
extension CategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns table size
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //pega o item correto para essa row
        let item = categoriesArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        //Display an image in the item
        content.image = UIImage(systemName: item.icon ?? "sparkles")
        
        cell.contentConfiguration = content
        
        return cell
    }
}

//For second sprint -- Make table items clickable and editable
