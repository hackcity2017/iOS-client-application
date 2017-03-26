//
//  MainViewController.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let viewmodel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewmodel.delegate = self
        self.viewmodel.startConnect()
    }
}

extension MainViewController: MainViewModelDelegate {
    func didConnectServer() {

    }

    func didDisconnectServer() {

    }

    func didMoveStart() {
        self.view.backgroundColor = UIColor.green
    }

    func didMoveEnd() {
        self.view.backgroundColor = UIColor.white
    }
}
