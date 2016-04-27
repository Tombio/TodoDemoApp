//
//  AddTodoViewController.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 27/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class AddTodoViewController: UIViewController {

    weak var delegate: TodoDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func toggleBoolean(sender: AnyObject) {
        if let text = self.textField.text {
            delegate?.addItem(TodoItem(title: text, dueDate: datePicker.date, color: UIColor.magentaColor()))
            navigationController?.popViewControllerAnimated(true)
        }
    }
}