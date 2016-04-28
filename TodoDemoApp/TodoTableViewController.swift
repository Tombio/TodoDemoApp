//
//  TodoTableViewController.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController: UITableViewController {
    
    let cellId = "TodoCell"
    var model: [TodoItem] = Array()
    var modelExpired: [TodoItem] = Array()
    
    @IBOutlet weak var table: UITableView!
    
    var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }
    
    override func viewDidLoad() {
        table.rowHeight = UITableViewAutomaticDimension
        table.dataSource = self
        table.delegate = self
        table.allowsSelectionDuringEditing = false
        table.allowsSelection = false
        table.allowsMultipleSelection = false
        
        model.append(TodoItem(title: "Buy milk", dueDate: nil, color: UIColor(40, 209, 22, 100)))
        model.append(TodoItem(title: "Eat your vegetables", dueDate: NSDate(), color: UIColor(40, 209, 22, 100)))
        model.append(TodoItem(title: "Fix this app", dueDate: NSDate(), color: UIColor(255, 157, 27, 100)))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    
    func expireRow(row: Int) {
        modelExpired.append(model.removeAtIndex(row))
    }
    
    func deleteRow(row: Int, section: Int) {
        if section == 0 {
            model.removeAtIndex(row)
        }
        else {
            modelExpired.removeAtIndex(row)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? model.count : modelExpired.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active" : "Done"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! TodoTableViewCell
        let index = indexPath.row
        let section = indexPath.section
        let item = section == 0 ? model[index] : modelExpired[index]
        
        cell.titleLabel.text = item.title
        if let date = item.dueDate {
            cell.dueLabel.text = dateFormatter.stringFromDate(date)
        }
        else {
            cell.dueLabel.text = ""
        }
        cell.colorLabel.backgroundColor = item.color
        return cell
    }
    
}