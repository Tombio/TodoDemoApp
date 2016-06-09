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
    
    let cellId = "TodoCell"
    var model: [ModelSection] = Array()
    
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
        
        model.append(ModelSection(name: SectionLabel.Active , items: []))
        model.append(ModelSection(name: SectionLabel.Done , items: []))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    
    func expireRow(indexPath: NSIndexPath) {
        model[indexPath.section].items[indexPath.row].expired = true
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        model[indexPath.section].items.removeAtIndex(indexPath.row)
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
        return model[section].items.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active" : "Done"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! TodoTableViewCell
        let index = indexPath.row
        let section = indexPath.section
        
        let item = model[section].items[index]
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
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Done", handler:{action, indexpath in
            self.expireRow(indexPath)
            self.table.editing = false
            self.table.reloadData()
        });
        moreRowAction.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.deleteRow(indexPath)
            self.table.editing = false
            self.table.reloadData()
        });
        
        return indexPath.section == 0 ? [deleteRowAction, moreRowAction] : [deleteRowAction];
    }
    
    // MARK: - TodoDelegate
    
    func addItem(item: TodoItem){
        model[0].items.append(item)
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