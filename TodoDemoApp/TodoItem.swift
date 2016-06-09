//
//  TodoItem.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 26/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

struct TodoItem {
    
    private static var idSequence: Int = 0
    
    let identifier = TodoItem.nextIdentifier()
    let title: String
    let dueDate: NSDate?
    let color: UIColor
    var expired = false
    
    static func nextIdentifier() -> Int {
        TodoItem.idSequence += 1
        return idSequence
    }
}