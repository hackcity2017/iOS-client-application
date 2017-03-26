//
//  Device.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class Device {

    class var identifier: String? {
        get {
            return UserDefaults.standard.value(forKey: "identifier") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "identifier")
        }
    }
}
