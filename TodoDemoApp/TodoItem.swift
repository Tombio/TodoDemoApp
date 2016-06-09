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
    
    enum Priority {
        case High
        case Normal
        case Low
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
}