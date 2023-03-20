//
//  AddCategoryViewController.swift
//  iBudget
//
//  Created by Sergio Golbert on 2023-02-01.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var catIcon: UIImageView!
    @IBOutlet weak var categotyNameTextField: UITextField!
    private var choosenIconName = "sparkles"
    private var cellSelected:categoryUICollectionView!
    @IBOutlet weak var uicollectionView: UICollectionView!
     
    var isEdit = false
    var editCategoryItem : Categories!
    
    @IBOutlet weak var categoryViewTitle: UILabel!
    private var icons = ["book","bicycle","play","gamecontroller","cart","case","greetingcard","newspaper","bookmark","graduationcap","paperclip","figure.basketball","figure.bowling","figure.core.training","figure.badminton","figure.hiking","water.waves","circlebadge","candybarphone","ipad.and.iphone","beats.headphones","carrot","music.note.tv","lightbulb","stethoscope","trash","box.truck"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uicollectionView.delegate = self
        uicollectionView.dataSource = self
        
        //unsetBackground(selectedCat:0,skipAll: true)
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        if isEdit {
            categotyNameTextField.text = editCategoryItem.name
            categoryViewTitle.text = "Edit Category"
        }
        

    }
//    @IBAction func saveButtonTouched(_ sender: Any) {
//        print(categotyNameTextField.hasText)
//        if(categotyNameTextField.hasText)
//        {
//            if let presenter = presentingViewController as? CategoryViewController{
//                //TODO: Not working?
//                presenter.saveCategory(newCategoryName: categotyNameTextField.text ?? "New Category", newCategoryIconName: choosenIconName)
//                print("saved")
//            }
//            //TODO: dismiss does not work correctly
//            self.navigationController?.popToRootViewController(animated: true)
//
//        }
//    }
    
    
    func unsetBackground(selectedCat : Int, skipAll: Bool) {
             
       let tags = [11,12,13,14,15,16]
        for _tag in tags {
            if(_tag != selectedCat)
            {
                DispatchQueue.main.async {
                    self.uicollectionView.viewWithTag(_tag)?.tintColor  = UIColor.darkGray
                }
            }else{
                if(!skipAll)
                {
                    DispatchQueue.main.async {
                        self.uicollectionView.viewWithTag(_tag)?.tintColor  = UIColor.systemIndigo
                    }
                }
            }
        }
    }
    
   
    
    
    
    
    
    
    
    @IBAction func buttonTouched(_ sender: UIButton) {
    
       // unsetBackground(selectedCat: sender.tag,skipAll: false)
        
//        switch sender.tag {
//        case 11:
//            choosenIconName = "book"
//        case 12:
//            choosenIconName = "bicycle"
//        case 13:
//            choosenIconName = "play"
//        case 14:
//            choosenIconName = "gamecontroller"
//        case 15:
//            choosenIconName = "cart"
//        case 16:
//            choosenIconName = "case"
//        case 0:
            //print(categotyNameTextField.hasText)
        if(!categotyNameTextField.hasText  )
        {
            let alert = UIAlertController(title: "Empty Category Name", message: "Please enter a name for your category", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(choosenIconName.isEmpty ||  choosenIconName == "sparkles")
        {
            let alert = UIAlertController(title: "Category icon not selected !", message: "Please select a icon for your category", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        if(categotyNameTextField.hasText && !isEdit)
        {
            
            let catName = categotyNameTextField.text?.glazeCamelCase ?? "New Category"
            
            saveCategory(newCategoryName: catName, newCategoryIconName: choosenIconName)
            
            
        }else{
            editCategory()
        }
//        default:
//            break
//        }
    }
    
    func editCategory(){
        
        
//        // Create a fetch request with a compound predicate
//        var IsExistfetchRequest = Categories.fetchRequest()
//
//        // Create the component predicates
//        let namePredicate = NSPredicate(
//            format: "name = %@", editCategoryItem.name!.description as String
//        )

//        let idPredicate = NSPredicate(
//            format: "id = %@", editCategoryItem.id!.description as String
//        )
        
        //let compound1 = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, idPredicate])
        // Create an "and" compound predicate, meaning the
        // query requires all the predicates to be satisfied.
        // In other words, for an object to be returned by
        // an "and" compound predicate, all the component
        // predicates must be true for the object.
//        IsExistfetchRequest.predicate = NSCompoundPredicate(
//            andPredicateWithSubpredicates: [
//                namePredicate,
//                idPredicate
//            ]
//        )
    
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
            fetchRequest.predicate = NSPredicate(format: "name =[c] %@", self.categotyNameTextField.text!)
            let results = try getContext().fetch(fetchRequest)
            if let foundCategory = results.first as? Categories {
                
                let dbId = foundCategory.id!.description as String
                let editedId  =  editCategoryItem.id!.description as String
                
                if dbId   != editedId  {
                    // create the alert
                    let alert = UIAlertController(title: "Duplicate Category!", message: "A category exists with this name already. Please enter a unique category name.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
          
                
          } catch {
            print("Error updating object: \(error)")
        }
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        fetchRequest.predicate = NSPredicate(format: "id == %@", editCategoryItem.id!.description as String)

        do {
            let results = try getContext().fetch(fetchRequest)
            if let editedCategory = results.first as? Categories {
                editedCategory.name = categotyNameTextField.text?.glazeCamelCase ?? "New Category"
                editedCategory.icon = choosenIconName
          
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                dismiss(animated: true)
            }
        } catch {
            print("Error updating object: \(error)")
        }
    }
    
    
    
    @IBAction func closeForm(_ sender: Any) {
        dismiss(animated: true)
    }
    public func saveCategory(newCategoryName: String, newCategoryIconName: String){
        
        //TODO: Function should check if there's already a category with this name
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
            fetchRequest.predicate = NSPredicate(format: "name =[c] %@", self.categotyNameTextField.text!)
            let results = try getContext().fetch(fetchRequest)
            
            if results.count > 0  {
                // create the alert
                let alert = UIAlertController(title: "Duplicate Category!", message: "A category exists with this name already. Please enter a unique category name.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    return
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                let cat = Categories(context: getContext())
                cat.name = newCategoryName.glazeCamelCase //?? "New Category"
                cat.type = 1
                let id = UUID()
                cat.id = id
                cat.icon = newCategoryIconName
                
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                self.dismiss(animated: true)
            }
           
                
          } catch {
            print("Error updating object: \(error)")
        }
        
        
     
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
}
    
    
   
extension AddCategoryViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count-1
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
 
//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        DispatchQueue.main.async {

        let collCell = collectionView.cellForItem(at: indexPath)  as! categoryUICollectionView

            if self.cellSelected !== nil {
                //if let imgView = self.cellSelected.viewWithTag(1) as? UIImageView {
                    //imgView.image = UIImage(systemName: self.icons[indexPath.row])
                self.cellSelected.imgView.tintColor = UIColor.label
                    
                //}
            }
            
//            collCell.contentView.tintColor = UIColor.systemPink
//
//            (self.uicollectionView.cellForItem(at: indexPath))?.tintColor = UIColor.systemPink
//
//            (self.uicollectionView.cellForItem(at: indexPath))?.backgroundView?.tintColor = UIColor.systemPink

           // if let imgView = collCell.viewWithTag(1) as? UIImageView {
                //imgView.image = UIImage(systemName: self.icons[indexPath.row])
                collCell.imgView.tintColor = UIColor.systemPink
                
           // }
            

            self.choosenIconName = self.icons[indexPath.row]
            self.cellSelected = collCell


        }
         
      
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "catImg", for: indexPath) as! categoryUICollectionView
         
        if isEdit &&  icons[indexPath.row] == editCategoryItem.icon {
            collCell.imgView.tintColor = .systemPink
            self.cellSelected = collCell
            self.choosenIconName = editCategoryItem.icon != "" ? editCategoryItem.icon!   : ""
        }
       // if let imgView = collCell.viewWithTag(1) as? UIImageView {
        collCell.imgView.image = UIImage(systemName: icons[indexPath.row])
        //}
        
        collCell.tag = indexPath.row
       
        return collCell
    }
    
    
 
    
}

class categoryUICollectionView : UICollectionViewCell {
    
 
    
    @IBOutlet weak var imgView: UIImageView!
    
}
