//
//  AddCategoryViewController.swift
//  iBudget
//
//  Created by Sergio Golbert on 2023-02-01.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categotyNameTextField: UITextField!
    private var choosenIconName = "sparkles"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func bookButtonTouched(_ sender: Any) {
        choosenIconName = "book"
    }
    
    @IBAction func bikeButtonTouched(_ sender: Any) {
        choosenIconName = "bicycle"
    }
    
    @IBAction func movieButtonTouched(_ sender: Any) {
        choosenIconName = "play"
    }
    
     @IBAction func controllerButtonTouched(_ sender: Any) {
         choosenIconName = "gamecontroller"
     }
    
    @IBAction func cartButtonTouched(_ sender: Any) {
        choosenIconName = "cart"
    }
    
    @IBAction func travelButtonTouched(_ sender: Any) {
        choosenIconName = "case"
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        if(categotyNameTextField.hasText)
        {
            if let presenter = presentingViewController as? CategoryViewController{
                presenter.saveCategory(newCategoryName: categotyNameTextField.text ?? "New Category", newCategoryIconName: choosenIconName)
            }
            //TODO: dismiss does not work correctly
            dismiss(animated: true)
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

}
