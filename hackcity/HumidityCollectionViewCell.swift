//
//  HumidityCollectionViewCell.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class HumidityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
    }

    func configure(value: Double) {
        self.humidityLabel.text = "\(String(format: "%.0f", value))"
    }
}
