//
//  Category.swift
//  Todoey
//
//  Created by Muzammil Muneer on 23/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""

    let items = List<Item>()
}
