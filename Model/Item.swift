//
//  Item.swift
//  ToDoApp
//
//  Created by Armin Spahic on 26/04/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
