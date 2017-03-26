//
//  AppDelegate.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Device.identifier = "00000000e8a8be46"
        return true
    }
}

