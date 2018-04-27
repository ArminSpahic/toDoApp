//
//  Category.swift
//  ToDoApp
//
//  Created by Armin Spahic on 26/04/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
   let items = List<Item>()
    
}
