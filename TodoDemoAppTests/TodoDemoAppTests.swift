//
//  TodoDemoAppTests.swift
//  TodoDemoAppTests
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import XCTest
@testable import TodoDemoApp

class TodoDemoAppTests: XCTestCase {
    
    let tableView = TodoTableViewController()
    
    override func setUp() {
        super.setUp()
        tableView.model.append(TodoItem(title: "Foobar Low", dueDate: NSDate(), priority: TodoItem.Priority.Low, expired: false))
        tableView.model.append(TodoItem(title: "Foobar High", dueDate: NSDate().dateByAddingTimeInterval(10), priority: TodoItem.Priority.High, expired: false))

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSort() {
        tableView.sort()
        assert(tableView.model.count == 2)
        assert(tableView.model[0].expired == false)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
