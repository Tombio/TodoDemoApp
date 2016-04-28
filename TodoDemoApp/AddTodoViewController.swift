//
//  AddTodoViewController.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 27/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class AddTodoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    let pickerData = ["Green": UIColor(40, 209, 22, 100),
                      "Blue": UIColor(27, 105, 164, 100),
                      "Yellow": UIColor(255, 157, 27, 100),
                      "Red": UIColor(251, 27, 38, 100)]
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        colorPicker.dataSource = self
        colorPicker.delegate = self
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        let index = pickerData.startIndex.advancedBy(row)
        let key = pickerData.keys[index]
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel.backgroundColor = pickerData[key]
        }
        pickerLabel!.text = key
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
        
    }

}