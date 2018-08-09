//
//  Bean.swift
//  Coffee
//
//  Created by Khanh T. Pham on 6/4/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation

class Bean {
    var variety: String = ""
    var origin: String = ""
    var elevation: Int?
    var process: Process = .NA
    
    enum Process: String {
        case NA = "N/A"
        case Natural = "Natural"
        case Wet = "Wet"
    }
}
class Origin {
    let country: String
    var detail: String
    
    var dictionary: [String: Any] {
        return [Key.country: self.country, Key.detail: self.detail]
    }
    
    init(country: String) {
        self.country = country
        self.detail = ""
    }
    
    struct Key {
        static let country = "country"
        static let detail = "detail"
    }
}
/**
let origins = [
    "Brazil",
    "Vietnam",
    "Colombia",
    "Indonesia",
    "Ethiopia",
    "Honduras",
    "India",
    "Uganda",
    "Mexico",
    "Guatemala",
    "Peru",
    "Nicaragua",
    "China",
    "Ivory Coast",
    "Costa Rica",
    "Kenya",
    "Papua New Guinea",
    "Tanzania",
    "ElSalvador",
    "Ecuador",
    "Cameroon",
    "Laos",
    "Madagascar",
    "Gabon",
    "Thailand",
    "Venezuela",
    "Dominican Republic",
    "Haiti",
    "Democratic Republic of the Congo",
    "Rwanda",
    "Burundi",
    "Philippines",
    "Togo",
    "Guinea",
    "Yemen",
    "Cuba",
    "Panama",
    "Bolivia",
    "Timor Leste",
    "Central African Republic",
    "Nigeria",
    "Ghana",
    "SierraLeone",
    "Angola",
    "Jamaica",
    "Paraguay",
    "Malawi",
    "Trinidad and Tobago",
    "Zimbabwe",
    "Liberia"
]

let originDocumentID = [
    "Brazil",
    "Vietnam",
    "Colombia",
    "Indonesia",
    "Ethiopia",
    "Honduras",
    "India",
    "Uganda",
    "Mexico",
    "Guatemala",
    "Peru",
    "Nicaragua",
    "China",
    "IvoryCoast",
    "CostaRica",
    "Kenya",
    "PapuaNewGuinea",
    "Tanzania",
    "ElSalvador",
    "Ecuador",
    "Cameroon",
    "Laos",
    "Madagascar",
    "Gabon",
    "Thailand",
    "Venezuela",
    "DominicanRepublic",
    "Haiti",
    "DemocraticRepublicoftheCongo",
    "Rwanda",
    "Burundi",
    "Philippines",
    "Togo",
    "Guinea",
    "Yemen",
    "Cuba",
    "Panama",
    "Bolivia",
    "TimorLeste",
    "CentralAfricanRepublic",
    "Nigeria",
    "Ghana",
    "SierraLeone",
    "Angola",
    "Jamaica",
    "Paraguay",
    "Malawi",
    "TrinidadandTobago",
    "Zimbabwe",
    "Liberia"
]
*/

