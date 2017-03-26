//
//  MainViewModel.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import SocketIO

protocol MainViewModelDelegate: class {
    func didConnectServer()
    func didDisconnectServer()
    func didMoveStart()
    func didMoveEnd()
}

class MainViewModel {

    private let socket = SocketIOClient(socketURL: URL(string: "http://localhost:4242")!,
                                        config: [.log(true),
                                                 .forcePolling(true),
                                                 .extraHeaders(["device-id": "test"])])

    weak var delegate: MainViewModelDelegate?

    init() {
        socket.on("connect") {data, ack in
            self.delegate?.didConnectServer()
            print("socket connected")
        }

        socket.on("disconnect") { _, _ in
            self.delegate?.didDisconnectServer()
            print("socket disconnected")
        }

        socket.on("test-alert") {data, ack in
            print("data alert : \(data)")
            self.delegate?.didMoveStart()
        }

        socket.on("test-alert-stop") {data, ack in
            print("data alert : \(data)")
            self.delegate?.didMoveEnd()
        }
    }

    func startConnect() {
        socket.connect()
    }
}
