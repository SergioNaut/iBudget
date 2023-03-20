//
//  DatePickerController.swift
//  iBudget
//
//  Created by Chris-Brien Glaze on 17/03/2023.
//

import Foundation
import UIKit

extension ExpenseViewController : UIPickerViewDelegate, UIPickerViewDataSource  {
    
        
    
        // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return months.count
            } else {
                return years.count
            }
        }
        
        // MARK: - UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return months[row]
            } else {
                return years[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                selectedMonth = months[row]
            } else {
                selectedYear = years[row]
            }
            print("\(selectedMonth ?? "") \(selectedYear ?? "")")
        }
    
}
