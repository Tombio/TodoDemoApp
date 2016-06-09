//
//  TodoTableViewController.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController: UITableViewController, TodoDelegate {
    
    enum Section: Int {
        case Due = 0
        case Expired
    }
    
    let cellId = "TodoCell"
    var model: [TodoItem] = Array()
    
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
       
        model.append(TodoItem(title: "Buy milk", dueDate: nil, priority: .Normal, expired: false))
        model.append(TodoItem(title: "Eat your vegetables", dueDate: NSDate(), priority: .Low, expired: false))
        model.append(TodoItem(title: "Fix this app", dueDate: NSDate(), priority: .High, expired: false))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    
    func expireRow(row: Int) {
        model[row].expired = true
    }
    
    func deleteRow(row: Int, section: Int) {
        let id = model.filterByExpirationStatus(section == 1)[row].identifier
        model.removeById(id)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        table.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filterByExpirationStatus(section == 1).count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active" : "Expired"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! TodoTableViewCell
        let index = indexPath.row
        let section = indexPath.section
        let item = model.filterByExpirationStatus(section == 1)[index]
        cell.titleLabel.text = item.title
        if let date = item.dueDate {
            cell.dueLabel.text = dateFormatter.stringFromDate(date)
        }
        else {
            cell.dueLabel.text = ""
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Done", handler:{action, indexpath in
            self.expireRow(indexPath.row)
            self.table.editing = false
            self.table.reloadData()
        });
        moreRowAction.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.deleteRow(indexPath.row, section: indexPath.section)
            self.table.editing = false
            self.table.reloadData()
        });
        
        return indexPath.section == 0 ? [deleteRowAction, moreRowAction] : [deleteRowAction];
    }
    
    // MARK: - TodoDelegate
    
    func addItem(item: TodoItem){
        model.append(item)
        table.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addTodoVC = segue.destinationViewController as? AddTodoViewController {
            addTodoVC.delegate = self
        }
    }
}

protocol TodoDelegate: class {
    func addItem(item: TodoItem)
}