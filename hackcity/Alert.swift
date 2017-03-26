//
//  Alert.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import RealmSwift

class Alert: Object {
    dynamic var id: String = NSUUID().uuidString
    dynamic var date = Date()
    dynamic var value: Int = 0

    override class func primaryKey() -> String? { return "id" }
}
