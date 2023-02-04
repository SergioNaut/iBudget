//
//  AddCategoryViewController.swift
//  iBudget
//
//  Created by Sergio Golbert on 2023-02-01.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categotyNameTextField: UITextField!
    private var choosenIconName = "sparkles"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func buttonTouched(_ sender: UIButton) {
    
        switch sender.tag {
        case 1:
            choosenIconName = "book"
        case 2:
            choosenIconName = "bicycle"
        case 3:
            choosenIconName = "play"
        case 4:
            choosenIconName = "gamecontroller"
        case 5:
            choosenIconName = "cart"
        case 6:
            choosenIconName = "case"
        case 0:
            print(categotyNameTextField.hasText)
            if(categotyNameTextField.hasText)
            {
                saveCategory(newCategoryName: categotyNameTextField.text ?? "New Category", newCategoryIconName: choosenIconName)
                
                //TODO: dismiss does not work correctly
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    public func saveCategory(newCategoryName: String, newCategoryIconName: String){
        
        //TODO: Function should check if there's already a category with this name
        
        let category = Categories(context: getContext())
        category.name = newCategoryName
        category.type = 1
        var id = UUID()
        category.id = id
        category.icon = newCategoryIconName
        
        self.saveAll()
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
}
    
    
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

