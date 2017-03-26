//
//  MainViewModel.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights resserved.
//

import UIKit
import SocketIO

protocol MainViewModelDelegate: class {
    func didConnectServer()
    func didDisconnectServer()
    func didMoveStart()
    func didMoveEnd()
    func didUpdateInformations(temp: Double, hum: Double)
    func didupdateStepsCount(steps: Int)
    func didUpdateGiroscope(x: Double, y: Double, z: Double)
    func didUpdateAccelerometer(x: Double, y: Double, z: Double)
    func didUpdateSumOfTime(sum: Int)
}

class MainViewModel {

    private var socket: SocketIOClient!
    weak var delegate: MainViewModelDelegate?

    private func instance() {
        socket = SocketIOClient(socketURL: URL(string: "http://172.16.0.49:4242")!,
        config: [.log(false),
        .forcePolling(true),
        .extraHeaders(["device-id": Device.identifier ?? ""])])
    }

    func listen() {
        socket.on("connect") {data, ack in
            self.delegate?.didConnectServer()
            print("socket connected")
        }

        socket.on("disconnect") { _, _ in
            self.delegate?.didDisconnectServer()
            print("socket disconnected")
        }

        socket.on("\(Device.identifier ?? "")-alert") {data, ack in
            self.delegate?.didMoveStart()
        }

        socket.on("\(Device.identifier ?? "")-informations") {data, ack in
            guard let informations = data[0] as? [String:AnyObject] else {return}
            guard let json = informations["informations"] as? [String:AnyObject] else {return}
            self.delegate?.didUpdateInformations(temp: json["temperature"] as? Double ?? 0, hum: json["humidity"] as? Double ?? 0)
        }

        socket.on("\(Device.identifier ?? "")-alert-update") {data, ack in
            guard let json = data[0] as? [String:AnyObject] else {return}
            guard let informations = json["update"] as? [String:AnyObject] else {return}
            if let x = informations["x"] as? String, let y = informations["y"] as? String, let z = informations["z"] as? String {
                self.delegate?.didUpdateGiroscope(x: Double(x) ?? 0, y: Double(y) ?? 0, z: Double(z) ?? 0)
            }
            if let x = informations["x1"] as? String, let y = informations["x2"] as? String, let z = informations["x3"] as? String {
                self.delegate?.didUpdateAccelerometer(x: Double(x) ?? 0, y: Double(y) ?? 0, z: Double(z) ?? 0)
            }
        }

        socket.on("\(Device.identifier ?? "")-alert-stop") {data, ack in
            self.delegate?.didMoveEnd()
            guard let stepsJson = data[0] as? [String:AnyObject] else {return}
            guard let json = stepsJson["steps"] as? [String:AnyObject] else {return}
            if let number = json["steps"] as? String {
                self.delegate?.didupdateStepsCount(steps: Int(number) ?? 0)
            }
            if let number = json["sumOfTime"] as? String {
                self.delegate?.didUpdateSumOfTime(sum: Int(number) ?? 0)
            }
        }
    }

    func startConnect() {
        self.instance()
        self.listen()
        socket.connect()
    }
}
