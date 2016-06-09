//
//  Extension.swift
//  TodoDemoApp
//
//  Created by Tomi Lahtinen on 28/04/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/100)
    }
}

extension Array where Element : ItemProtocol {
    
    func filterByExpirationStatus(expired: Bool) -> [Element] {
        return self.filter({ $0.expired == expired })
    }
    
    mutating func removeById(id: Int) {
        self = self.filter({ $0.id != id })
    }
}

extension Int {
    
    mutating func next() -> Int {
        self += 1
        return self
    }
    
}