//
//  ChartView.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import SwiftChart
import SnapKit

class ChartView: UIView {

    private var valuesX = [Float]()
    private var valuesY = [Float]()
    private var valuesZ = [Float]()
    private var chart: Chart!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red:0.98, green:0.99, blue:1.00, alpha:1.00)
        for _ in 0...20 {
            valuesX.append(0)
            valuesY.append(0)
            valuesZ.append(0)
        }
    }

    func addValue(x: Double, y: Double, z: Double) {
        if valuesX.count > 20 {
            valuesX.removeFirst()
        }
        if valuesY.count > 20 {
            valuesY.removeFirst()
        }
        if valuesZ.count > 20 {
            valuesZ.removeFirst()
        }
        valuesX.append(Float(x))
        valuesY.append(Float(y))
        valuesZ.append(Float(z))
        self.configure()
    }

    func configure() {
        if chart != nil {
            self.chart.removeFromSuperview()
        }
        chart = Chart()
        chart.backgroundColor = UIColor(red:0.98, green:0.99, blue:1.00, alpha:1.00)
        chart.axesColor = UIColor.clear
        chart.gridColor = UIColor.clear
        chart.lineWidth = 7
        chart.xLabels = nil
        chart.yLabels = nil
        chart.minY = 0
        chart.maxY = 10
        chart.labelFont = UIFont.boldSystemFont(ofSize: 0)
        self.addSubview(chart)

        chart.snp.makeConstraints({ make in
            make.edges.equalTo(self)
        })

        let series1 = ChartSeries(valuesX)
        series1.color = ChartColors.greenColor()
        series1.area = true

        let series2 = ChartSeries(valuesY)
        series2.color = ChartColors.blueColor()
        series2.area = true

        let series3 = ChartSeries(valuesZ)
        series3.color = ChartColors.redColor()
        series3.area = true

        chart.removeAllSeries()

        chart.add(series1)
        chart.add(series2)
        chart.add(series3)
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
