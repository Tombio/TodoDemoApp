//
//  Persistence.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 14/06/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation

class Persistence {

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let savedItemsKey: String = "SavedItems"

    func persist(items: [TodoItem]) {
        let archive = NSKeyedArchiver.archivedDataWithRootObject(items)
        userDefaults.setObject(archive, forKey: savedItemsKey)
        userDefaults.synchronize()
    }
    
    func load() -> [TodoItem] {
        guard let items = userDefaults.objectForKey(savedItemsKey) else {
            return []
        }
        return NSKeyedUnarchiver.unarchiveObjectWithData(items as! NSData) as! [TodoItem]
    }
}