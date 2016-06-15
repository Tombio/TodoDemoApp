//
//  TodoTableViewController.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoDelegate {

    enum Section: Int {
        case Due = 0, Expired
    }
    
    // Raw values are bound to UISegmentedController's segment indices, so keep them in order
    // and synchronized
    enum SortKey: Int {
        case Date = 0, Priority
    }
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var sortOrderControl: UISegmentedControl!
    
    @IBAction func sort(sender: UISegmentedControl) {
        if let sortKey = SortKey.init(rawValue: sender.selectedSegmentIndex) {
            self.currentSort = sortKey
        }
        sort()
    }
    
    let cellId = "TodoCell"
    var model: [TodoItem] = Array()
    var persistence = Persistence()
    var currentSort = SortKey.Date
    
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
       
        model = persistence.load()
        sort()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    
    func expireRow(row: Int, section: Int) {
        let elements = model.filterByExpirationStatus(section == 1)
        if let modelIndex = model.indexOf(elements[row]){
            model[modelIndex].expired = true
        }
        persistence.persist(model)
    }
    
    func deleteRow(row: Int, section: Int) {
        let id = model.filterByExpirationStatus(section == 1)[row]
        model.removeElement(id)
        persistence.persist(model)
    }
    
    func sort(){
        if currentSort == .Date {
            model.sortInPlace( {
                let first = $0.dueDate ?? NSDate.distantFuture()
                let second = $1.dueDate ?? NSDate.distantFuture()
                return first.compare(second) == .OrderedAscending
            })
        }
        else if currentSort == .Priority {
            model.sortInPlace( {
                if $0.priority.rawValue != $1.priority.rawValue {
                    return $0.priority.rawValue < $1.priority.rawValue
                }
                else {
                    return $0.title.compare($1.title) == .OrderedAscending
                }
            })
        }
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        table.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filterByExpirationStatus(section == 1).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active" : "Expired"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        
        cell.priorityLabel.text = item.priority.humanReadable
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Done", handler:{ action, indexpath in
            self.expireRow(indexPath.row, section: indexPath.section)
            self.table.editing = false
            self.sort()
            self.table.reloadData()
        });
        moreRowAction.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{ action, indexpath in
            self.deleteRow(indexPath.row, section: indexPath.section)
            self.table.editing = false
            self.sort()
            self.table.reloadData()
        });
        
        return indexPath.section == 0 ? [deleteRowAction, moreRowAction] : [deleteRowAction];
    }
    
    
    
    // MARK: - TodoDelegate
    
    func addItem(item: TodoItem){
        model.append(item)
        persistence.persist(model)
        sort()
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