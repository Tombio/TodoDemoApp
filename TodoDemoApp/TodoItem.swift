//
//  TodoItem.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

struct TodoItem: ItemProtocol {
    
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
    
    static func nextIdentifier() -> Int {
        TodoItem.idSequence += 1
        return idSequence
    }
    
    let identifier = TodoItem.nextIdentifier()
    let title: String
    let dueDate: NSDate?
    let priority: Priority
    var expired: Bool
}

protocol ItemProtocol {
    var identifier: Int { get }
    var expired: Bool { get set }
    var dueDate: NSDate? { get }
}