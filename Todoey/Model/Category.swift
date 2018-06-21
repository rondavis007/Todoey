//
//  Category.swift
//  Todoey
//
//  Created by Ron Davis on 6/20/18.
//  Copyright © 2018 Reactuate Software. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colorInHex : String = "#FFFFFF"
    let items = List<Item>()
    
}
