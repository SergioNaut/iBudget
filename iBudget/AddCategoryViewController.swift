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
    override func viewDidLoad() {
        super.viewDidLoad()
        unsetBackground(selectedCat:0,skipAll: true)
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()

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
                    
                    self.view.viewWithTag(_tag)?.tintColor  = UIColor.darkGray
                }
            }else{
                if(!skipAll)
                {
                    DispatchQueue.main.async {
                        self.view.viewWithTag(_tag)?.tintColor  = UIColor.systemIndigo
                    }
                }
            }
        }
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
    
        unsetBackground(selectedCat: sender.tag,skipAll: false)
        
        switch sender.tag {
        case 11:
            choosenIconName = "book"
        case 12:
            choosenIconName = "bicycle"
        case 13:
            choosenIconName = "play"
        case 14:
            choosenIconName = "gamecontroller"
        case 15:
            choosenIconName = "cart"
        case 16:
            choosenIconName = "case"
        case 0:
            //print(categotyNameTextField.hasText)
            if(categotyNameTextField.hasText)
            {
                saveCategory(newCategoryName: categotyNameTextField.text ?? "New Category", newCategoryIconName: choosenIconName)
                
                self.dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    @IBAction func closeForm(_ sender: Any) {
        dismiss(animated: true)
    }
    public func saveCategory(newCategoryName: String, newCategoryIconName: String){
        
        //TODO: Function should check if there's already a category with this name
        
        let cat = Categories(context: getContext())
        cat.name = newCategoryName
        cat.type = 1
        let id = UUID()
        cat.id = id
        cat.icon = newCategoryIconName
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
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

