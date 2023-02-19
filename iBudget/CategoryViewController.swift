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
    let readOnlyCategories = ["food","housing","transportation","utilities","medical"]
    var CanActionPerformed = true
    //var newCategory = CategoryValues.init(name: "newCategory", iconName: "sparkle")
    
    var isEdit: Bool = false
    var selectedCategory: Categories!
    
    
    @IBAction func addCategoryButtonTapped(_ sender: UIButton) {
        
       performSegue(withIdentifier: "addCategory", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategory" {
            let destinationVC = segue.destination as? AddCategoryViewController
            destinationVC?.isEdit = isEdit
            destinationVC?.editCategoryItem = selectedCategory
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadCategories()
        categoriesTableView.dataSource = self
        
        //Uncomment later when categories need to be clickable
        categoriesTableView.delegate = self
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }

    func loadCategories(){
        //TODO: Use to load original categories for the first time
        categoriesArray = []
        let request1: NSFetchRequest<Categories> = Categories.fetchRequest()
            do {
                let items = try getContext().fetch(request1)
                print(items.count)
                categoriesArray.append(contentsOf: items)
                categoriesTableView.reloadData()
                
    
            } catch {
                print ("error fetching data: \(error)")
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //categoriesTableView.reloadData()
        loadCategories()
    }
}

struct CategoryValues {
    let name: String
    let iconName: String
}

//Extension for TableView
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns table size
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
   
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //TODO: dont allow edit of system categories
        let item = categoriesArray[indexPath.row]
        let catName  = (item.name?.lowercased())!
        print(catName)
        if readOnlyCategories.contains(catName) {
            CanActionPerformed = false
            return UISwipeActionsConfiguration(actions: [])
        }else {
            CanActionPerformed = true
           
        }
            let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view,actionPerformed:
                                                                                (Bool) -> ()) in
                self.isEdit = true
                self.selectedCategory = self.categoriesArray[indexPath.row]
                self.performSegue(withIdentifier: "addCategory", sender: nil)
                self.isEdit = false
                actionPerformed(self.CanActionPerformed)
            }
            
            edit.backgroundColor = .systemTeal
            return UISwipeActionsConfiguration(actions: [edit])
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! categoryCell
        //pega o item correto para essa row
        let item = categoriesArray[indexPath.row]
        cell.categoryName.text = item.name
        cell.icon.image = UIImage(systemName: item.icon ?? "sparkles")?.withTintColor(UIColor.systemIndigo)
        return cell
    }
}

//For second sprint -- Make table items clickable and editable


class categoryCell : UITableViewCell {
    
    @IBOutlet weak var icon :UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
}
