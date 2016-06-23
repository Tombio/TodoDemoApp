//
//  TodoTableViewControllerTest.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 15/06/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import XCTest
@testable import TodoDemoApp

class TodoTableViewControllerTest: XCTestCase {

    let tableView = TodoTableViewController()
    let persistenceMock = PersistenceMock()
    
    let item1 = TodoItem(title: "First", dueDate: NSDate(), priority: TodoItem.Priority.Low, expired: false)
    let item2 = TodoItem(title: "Second", dueDate: NSDate().dateByAddingTimeInterval(10), priority: TodoItem.Priority.High, expired: false)
    let item3 = TodoItem(title: "Third", dueDate: NSDate().dateByAddingTimeInterval(-10), priority: TodoItem.Priority.Normal, expired: true)
    let item4 = TodoItem(title: "Fourth", dueDate: NSDate().dateByAddingTimeInterval(20), priority: TodoItem.Priority.Low, expired: false)
    let item5 = TodoItem(title: "Fifth", dueDate: NSDate().dateByAddingTimeInterval(-20), priority: TodoItem.Priority.Normal, expired: true)
    
    override func setUp() {
        super.setUp()
        tableView.persistence = persistenceMock
        tableView.model.append(item1)
        tableView.model.append(item2)
        tableView.model.append(item3)
        tableView.model.append(item4)
        tableView.model.append(item5)
        
        tableView.model.shuffleInPlace()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSortModelByDate() {
        tableView.currentSort = TodoTableViewController.SortKey.Date
        for _ in 0.stride(to: 1000, by: 1){
            tableView.model.shuffleInPlace()
            tableView.sort()
            XCTAssertTrue(tableView.model.count == 5, "Model contains correct amount of rows")
            XCTAssertTrue(tableView.model[0] == item5)
            XCTAssertTrue(tableView.model[1] == item3)
            XCTAssertTrue(tableView.model[2] == item1)
            XCTAssertTrue(tableView.model[3] == item2)
            XCTAssertTrue(tableView.model[4] == item4)
        }
    }
    
    func testSortModelByPriority() {
        tableView.currentSort = TodoTableViewController.SortKey.Priority
        for _ in 0.stride(to: 1000, by: 1){
            tableView.model.shuffleInPlace()
            tableView.sort()
            XCTAssertTrue(tableView.model.count == 5, "Model contains correct amount of rows")
            XCTAssertTrue(tableView.model[0] == item2)
            XCTAssertTrue(tableView.model[1] == item5)
            XCTAssertTrue(tableView.model[2] == item3)
            XCTAssertTrue(tableView.model[3] == item1)
            XCTAssertTrue(tableView.model[4] == item4)
        }
    }
    
    func testFilterByExpirationStatusNotExpired(){
        let items = tableView.model.filterByExpirationStatus(false)
        XCTAssertEqual(items.count, 3)
        XCTAssertTrue(items.contains(item1))
        XCTAssertTrue(items.contains(item2))
        XCTAssertTrue(items.contains(item4))
    }
    
    func testFilterByExpirationStatusExpired(){
        let items = tableView.model.filterByExpirationStatus(true)
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains(item3))
        XCTAssertTrue(items.contains(item5))
    }
    
    func testDeleteRow() {
        tableView.sort()
        tableView.deleteRow(0, section: 0)
        XCTAssertTrue(tableView.model.count == 4, "Model contains correct number of rows")
        XCTAssertTrue(persistenceMock.persistCount == 1, "Persisting of items called after delete")
    }
    
    func testExpireRow() {
        tableView.sort()
        tableView.expireRow(0, section: 0)
        XCTAssertTrue(tableView.model.count == 5, "Model contains correct number of rows")
        XCTAssertTrue(persistenceMock.persistCount == 1, "Persisting of items called after delete")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
