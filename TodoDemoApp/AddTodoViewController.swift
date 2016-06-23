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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var prioritySelector: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    weak var delegate: TodoDelegate?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.addTarget(self, action: #selector(validateTextField), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    @IBAction func addItem(sender: AnyObject) {
        if let text = textField.text?.trim() {
            delegate?.addItem(TodoItem(title: text, dueDate: datePicker.date, priority: self.priority, expired: false))
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    var priority: TodoItem.Priority {
        switch prioritySelector.selectedSegmentIndex {
        case 0:
            return TodoItem.Priority.Low
        case 1:
            return TodoItem.Priority.Normal
        case 2:
            return TodoItem.Priority.High
        default:
            return TodoItem.Priority.Normal
        }
    }
    
    // Mark: -- TextField Validation
    
    func validateTextField() {
        saveButton.enabled = !textField.text!.trim().isEmpty
    }
}