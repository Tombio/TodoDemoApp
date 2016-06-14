//
//  TodoItem.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class TodoItem: NSObject, NSCoding, ItemProtocol {
    
    enum Priority: Int {
        
        case High = 0, Normal, Low
        
        var humanReadable: String {
            switch self {
            case High:
                return "!!!"
            case Normal:
                return "!!"
            case Low:
                return "!"
            }
        }
    }
    
    private static var idSequence: Int = 0
    let identifier: Int
    let title: String
    let dueDate: NSDate?
    let priority: Priority
    var expired: Bool
    
    static func nextIdentifier() -> Int {
        TodoItem.idSequence += 1
        return idSequence
    }
    
    required init(title: String, dueDate: NSDate?, priority: Priority, expired: Bool) {
        self.identifier = TodoItem.nextIdentifier()
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.expired = expired
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        identifier = aDecoder.decodeObjectForKey("identifier") as! Int
        title = aDecoder.decodeObjectForKey("title") as! String
        dueDate = aDecoder.decodeObjectForKey("dueDate") as? NSDate
        priority = Priority.init(rawValue: aDecoder.decodeObjectForKey("priority") as! Int)!
        expired = aDecoder.decodeObjectForKey("expired") as! Bool
        
        // Make sure id sequence value is high enough to prevent clashes
        TodoItem.idSequence = max(TodoItem.idSequence, identifier)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(dueDate, forKey: "dueDate")
        aCoder.encodeObject(priority.rawValue, forKey: "priority")
        aCoder.encodeObject(expired, forKey: "expired")
    }
    
}

protocol ItemProtocol {
    var identifier: Int { get }
    var expired: Bool { get set }
    var dueDate: NSDate? { get }
}