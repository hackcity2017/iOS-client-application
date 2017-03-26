//
//  SumOfTimeCollectionViewCell.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class SumOfTimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
    }

    func configure(value: Int) {
        if value > 60 {
            self.labelTime.text = "\(value / 60)m"
        } else {
            self.labelTime.text = "\(value)s"
        }
    }
}
