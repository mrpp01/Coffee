//
//  Grinder.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/3/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Grinder {
    
    var name: String
    var brand: String
    var range: Range<Int>
    
    init(brand: String, name: String, range: Range<Int>) {
        self.brand = brand
        self.name = name
        self.range = range
    }
    
    enum GrindSize: String {
        case Fine = "Fine"
        case MediumFine = "Medium Fine"
        case Medium = "Medium"
        case MediumCoarse = "Medium Coarse"
        case Coarse = "Coarse"
        case NA = "N/A"
    }
}

class OtherGrinder: Grinder {
    static let documentID: String = "Others"
}


