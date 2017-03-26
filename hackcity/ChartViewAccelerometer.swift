//
//  ChartViewAccelerometer.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import SwiftChart
import SnapKit

class ChartViewAccelerometer: UIView {

    private var valuesX = [Float]()
    private var chart: Chart!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        for _ in 0...20 {
            valuesX.append(0)
        }
    }

    func addValue(x: Double, y: Double, z: Double) {
        if valuesX.count > 20 {
            valuesX.removeFirst()
        }
        valuesX.append(Float(x))
        self.configure()
    }

    func configure() {
        if chart != nil {
            self.chart.removeFromSuperview()
        }
        chart = Chart()
        chart.backgroundColor = UIColor.clear
        chart.axesColor = UIColor.clear
        chart.gridColor = UIColor.clear
        chart.lineWidth = 7
        chart.xLabels = nil
        chart.yLabels = nil
        chart.minY = 0
        chart.maxY = 5
        chart.labelFont = UIFont.boldSystemFont(ofSize: 0)
        self.addSubview(chart)

        chart.snp.makeConstraints({ make in
            make.edges.equalTo(self)
        })

        let series1 = ChartSeries(valuesX)
        series1.color = ChartColors.greyColor()
        series1.area = true

        chart.removeAllSeries()

        chart.add(series1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = Bundle.main.loadNibNamed("ChartView", owner: self, options: nil)?[0] as? UIView else {
            return
        }
        self.addSubview(view)
        view.frame = self.bounds
    }
}
