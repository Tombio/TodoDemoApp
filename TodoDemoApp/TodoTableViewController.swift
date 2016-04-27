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
    
    var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        table.rowHeight = UITableViewAutomaticDimension
        table.dataSource = self
        table.delegate = self
        table.allowsSelectionDuringEditing = false
        table.allowsMultipleSelection = false

        model.append(TodoItem(title: "Buy milk", dueDate: nil, color: UIColor.greenColor()))
        model.append(TodoItem(title: "Eat your vegetables", dueDate: NSDate(), color: UIColor.yellowColor()))
        model.append(TodoItem(title: "Fix this app", dueDate: NSDate(), color: UIColor.blackColor()))
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
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? model.count : modelExpired.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active" : "Expired"
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Done", handler:{action, indexpath in
            self.expireRow(indexPath.row)
            tableView.editing = false
            tableView.reloadData()
        });
        moreRowAction.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.deleteRow(indexPath.row, section: indexPath.section)
            tableView.editing = false
            tableView.reloadData()
        });
    
        return indexPath.section == 0 ? [deleteRowAction, moreRowAction] : [deleteRowAction];
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
    }
}