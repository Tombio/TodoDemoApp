//
//  PersistenceMock.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 15/06/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation

class PersistenceMock: Persistence {
    
    var loadCount = 0
    var persistCount = 0
    
    override func load() -> [TodoItem] {
        loadCount += 1
        return []
    }
    
    override func persist(items: [TodoItem]) {
        persistCount += 1
        // NOP
    }
}