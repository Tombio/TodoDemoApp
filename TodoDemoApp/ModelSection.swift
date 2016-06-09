//
//  ModelSection.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 30/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation

enum SectionLabel: String {
    case Active = "Active"
    case Done = "Done"
}

struct ModelSection {

    let name: SectionLabel
    var items: [TodoItem]
    
}