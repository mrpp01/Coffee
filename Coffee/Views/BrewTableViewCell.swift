//
//  BrewTableViewCell.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/7/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit

class BrewTableViewCell: ActivityTableViewCell {
    static let identifer: String = "Brew Cell"
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var beanLabel: UILabel!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    @IBOutlet weak var methodImageLabel: UIImageView!
    
}
