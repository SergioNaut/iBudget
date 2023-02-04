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
        
        //TODO: First add categories from data storage, then, if empty, add the basic categories.
        if(categoriesArray.isEmpty)
        {
            let category = Categories(context: getContext())
            category.name = "Food"
            //Set type as 0 because they are the predefined categories
            category.type = 0
            var id = UUID()
            category.id = id
            //TODO: Change icons
            category.icon = "fork.knife"
            categoriesArray.append(category)
            
            let category2 = Categories(context: getContext())
            category2.name = "Housing"
            //Set type as 0 because they are the predefined categories
            category2.type = 0
            id = UUID()
            category2.id = id
            //TODO: Change icons
            category2.icon = "house"
            categoriesArray.append(category2)
            
            let category3 = Categories(context: getContext())
            category3.name = "Transportation"
            //Set type as 0 because they are the predefined categories
            category3.type = 0
            id = UUID()
            category3.id = id
            //TODO: Change icons
            category3.icon = "car"
            categoriesArray.append(category3)
            
            let category4 = Categories(context: getContext())
            category4.name = "Utilities"
            //Set type as 0 because they are the predefined categories
            category4.type = 0
            id = UUID()
            category4.id = id
            //TODO: Change icons
            category4.icon = "wrench.and.screwdriver"
            categoriesArray.append(category4)
            
            let category5 = Categories(context: getContext())
            category5.name = "Medical"
            //Set type as 0 because they are the predefined categories
            category5.type = 0
            id = UUID()
            category5.id = id
            //TODO: Change icons
            category5.icon = "cross"
            categoriesArray.append(category5)
            
            self.saveAll()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
