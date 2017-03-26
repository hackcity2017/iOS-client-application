//
//  MainViewController.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import RateLimit
import MKRingProgressView
import Timepiece
import FFToast


class MainViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!
    private let viewmodel = MainViewModel()
    fileprivate var currentValue: Int = 0
    private var debouncedLimiter: DebouncedLimiter!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    fileprivate var temp: Double = 0.0
    fileprivate var humidity: Double = 0.0
    fileprivate var steps: Double = 0.0
    fileprivate var sumOfTime: Int = 0
    @IBOutlet weak var labelTime: UILabel!
    fileprivate var startDate: Date?
    fileprivate var count = 0
    @IBOutlet weak var chartView2: ChartViewAccelerometer!

    private func configureUI() {
        self.chartView.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Device.identifier == nil {
            self.performSegue(withIdentifier: "mainviewmodal", sender: nil)
        } else {
            self.configureUI()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 1.8, height: 130)
        self.collectionViewFlowLayout.minimumLineSpacing = 0
        self.collectionViewFlowLayout.minimumInteritemSpacing = 0
        self.collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionview.showsHorizontalScrollIndicator = false
        self.collectionview.dataSource = self
        let nib1 = UINib(nibName: "TemperatureCollectionViewCell", bundle: nil)
        let nib2 = UINib(nibName: "HumidityCollectionViewCell", bundle: nil)
        let nib3 = UINib(nibName: "StepsCollectionViewCell", bundle: nil)
        let nib4 = UINib(nibName: "SumOfTimeCollectionViewCell", bundle: nil)
        self.collectionview.backgroundColor = UIColor.clear
        self.collectionview.register(nib1, forCellWithReuseIdentifier: "tempCell")
        self.collectionview.register(nib2, forCellWithReuseIdentifier: "humCell")
        self.collectionview.register(nib3, forCellWithReuseIdentifier: "stepsCell")
        self.collectionview.register(nib4, forCellWithReuseIdentifier: "timeCell")
        self.collectionview.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewmodel.startConnect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelTime.text = nil
        self.labelTime.isHidden = true

        self.title = "Stopped"
        self.viewmodel.delegate = self
        self.view.backgroundColor = UIColor(red:0.98, green:0.99, blue:1.00, alpha:1.00)

        debouncedLimiter = DebouncedLimiter(limit: 1) { [weak self] in
            defer {
                self?.debouncedLimiter.execute()
            }
            guard let _ = self?.startDate else {return}
            self?.count += 1
            print("💧 \(self?.count)")
            DispatchQueue.main.async {
                self?.labelTime.text = "\(self?.count ?? 0) seconds"
            }
        }
        debouncedLimiter.execute()
    }
}

extension MainViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "tempCell", for: indexPath) as! TemperatureCollectionViewCell
            cell.configure(value: self.temp)
            return cell
        case 1:
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "humCell", for: indexPath) as! HumidityCollectionViewCell
            cell.configure(value: self.humidity)
            return cell
        case 2:
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "stepsCell", for: indexPath) as! StepsCollectionViewCell
            cell.configure(value: self.steps)
            return cell
        case 3:
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! SumOfTimeCollectionViewCell
            cell.configure(value: self.sumOfTime)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: MainViewModelDelegate {

    func didUpdateAccelerometer(x: Double, y: Double, z: Double) {
//        if x > 5 || y > 5 || z > 5 {
//        }
//        print("\(x), \(y), \(z)")
//        self.chartView2.addValue(x: abs(y), y: abs(y), z: z)
    }

    func didUpdateSumOfTime(sum: Int) {
        self.sumOfTime = sum
        self.collectionview.reloadData()
    }

    func didUpdateGiroscope(x: Double, y: Double, z: Double) {
        self.chartView.addValue(x: x, y: y, z: z)
    }

    func didupdateStepsCount(steps: Int) {
        self.steps = Double(steps)
        self.collectionview.reloadData()
    }

    func didUpdateInformations(temp: Double, hum: Double) {
        self.temp = temp
        self.humidity = hum
        self.collectionview.reloadData()
    }

    func didConnectServer() {

    }

    func didDisconnectServer() {

    }

    func didMoveStart() {
        FFToast.show(withTitle: "Started moving", message: nil, iconImage: nil, duration: 2, toastType: FFToastType.info)
        self.startDate = Date()
        self.count = 0
        self.labelTime.isHidden = false
        self.labelTime.text = "0 seconds"
        self.title = "Moving"
        self.currentValue = 1
    }

    func didMoveEnd() {
        FFToast.show(withTitle: "Stopped moving", message: nil, iconImage: nil, duration: 2, toastType: FFToastType.info)
        self.title = "Stopped"
        self.startDate = nil
        self.labelTime.isHidden = true
        self.currentValue = 0
        self.labelTime.text = nil
    }
}
