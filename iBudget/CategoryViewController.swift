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
    
    func deleteCategory(index: Int){
        getContext().delete(categoriesArray[index])
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              
              let item = categoriesArray[indexPath.row]
              let catName  = (item.name?.lowercased())!
              print(catName)
              if readOnlyCategories.contains(catName) {
                  let alert = UIAlertController(title: "Delete Error", message: "Basic categories cannot be deleted", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        return
                      
                      }))
                  self.present(alert, animated: true,completion: nil)
              }
              
              let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
                  
                  do {
                      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
                      fetchRequest.predicate = NSPredicate(format: "categoryId = %@", self.categoriesArray[indexPath.row].id!.description as String)
                      let results = try self.getContext().fetch(fetchRequest)
                      
                      if results.count > 0  {
                          // create the alert
                          let alert = UIAlertController(title: "Category in use!", message: "A category is in use. Please delete the expenses before.", preferredStyle: UIAlertController.Style.alert)
                          
                          // add an action (button)
                          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                              return
                          }))
                          
                          // show the alert
                          self.present(alert, animated: true, completion: nil)
                          
                      }else{
                          self.deleteCategory(index: indexPath.row)
                          self.categoriesArray.remove(at: indexPath.row)
                          AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                          tableView.deleteRows(at: [indexPath], with: .fade)
                    
                          self.dismiss(animated: true)
                      }
                     
                          
                    } catch {
                      print("Error updating object: \(error)")
                  }
              }))
              
              alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Ignore"), style: .cancel, handler: { _ in
                
              }))
              self.present(alert, animated: true, completion: nil)
          }
      }
}

//For second sprint -- Make table items clickable and editable


class categoryCell : UITableViewCell {
    
    @IBOutlet weak var icon :UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
}
