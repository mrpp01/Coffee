//
//  Flavor.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/20/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
let flavor: [String: [String]] = [
"Floral": ["Black Tea", "Floral"], "Fruity": ["Berry", "Dried Fruit", "Other Fruit", "Citrus Fruit"],
"Sour": ["Sour", "Alcohol"], "Green": ["Olive Oil", "Raw", "Vegetative"],
"Other": ["Chemical", "Papery"], "Roasted": ["Tobaco", "Pipe Tobaco", "Cereal", "Burnt"],
"Spices": ["Peper", "Pungent", "Brown Spices"], "Nutty Cocoa": ["Nutty", "Cocoa"],
"Sweet": ["Sweet Aromatics", "Overall Sweet", "Vanillin", "Vanilla", "Brown Suger"]
]

class Flavor {
    private(set) var section: String
    private(set) var subSection: String
    
    static let wheel: [String: [String]] = [
        "Floral": ["Black Tea", "Floral"], "Fruity": ["Berry", "Dried Fruit", "Other Fruit", "Citrus Fruit"],
        "Sour": ["Sour", "Alcohol"], "Green": ["Olive Oil", "Raw", "Vegetative"],
        "Other": ["Chemical", "Papery"], "Roasted": ["Tobaco", "Pipe Tobaco", "Cereal", "Burnt"],
        "Spices": ["Peper", "Pungent", "Brown Spices"], "Nutty Cocoa": ["Nutty", "Cocoa"],
        "Sweet": ["Sweet Aromatics", "Overall Sweet", "Vanillin", "Vanilla", "Brown Suger"]
    ]
    
    private init(for section: String, with subSection: String) {
        self.section = section
        self.subSection = subSection
    }
    
    static func allFlavors() -> [Flavor] {
        var flavors = [Flavor]()
        
        for section in wheel.keys {
            let subSections = wheel[section]!
            for subSection in subSections {
                flavors.append(Flavor(for: section, with: subSection))
            }
        }
        
        return flavors
    }
    
    

}

enum Taste {
    
    enum Floral {
        case blackTea
        enum Floral {
            case chamomile, rose, jasmine
        }
    }
    
    enum Fruity {
        enum Berry {
            case blackberry, raspberry, blueberry, strawberry
        }
        enum DriedFruit {
            case raisin, prune
        }
        enum OtherFruit {
            case coconut, cherry, pomegranate, pineapple, grape, apple, peach, pear
        }
        enum CitrusFruit {
            case grapefruit, orange, lemon, lime
        }
    }
    
    enum Sour {
        enum Sour {
            case sourAromatics, aceticAcid, butyricAcid, isovalericAcid, citricAcid, malicAcid
        }
        enum Alcohol {
            case winey, whiskey, fermented, overripe
        }
    }
    
    enum Green {
        case oliveOil
        case raw
        enum Vegetative {
            case underRipe, peapod, fresh, darkGreen, veggetative, haylike, herblike
        }
        case beany
    }
    
    enum Other {
        enum Chemical {
            case rubber, skunky, petroleum, medicinal, salty, bitter
        }
        enum Papery {
            case phenolic, meatyBrothy, animalic, mustyEarhty, mustyDusty, moldyDamp, woody, papery, cardboard, stale
        }
    }
    
    enum Roasted {
        case tobaco
        case pipeTobaco
        enum Cereal {
            case malt, grain
        }
        enum Burnt {
            case brownRoast, smoky, ashy, acrid
        }
    }
    
    enum Spices {
        case pepper, pungent
        enum BrownSpice {
            case anise, nutmeg, cinamon, clove
        }
    }
    
    enum NuttyCocoa {
        enum Nutty {
            case peanuts, hazelnut, almond
        }
        enum Cocoa {
            case chocolate, darkChocolate
        }
    }
    
    enum Sweet {
        case sweetAromatics, overallSweet, vanillin, vanilla
        enum BrownSuger {
            case molasses, mappleSyrup, caramelized, honey
        }
    }
}

extension Flavor: Searchable {
    func contains(keyword: String) -> Bool {
        return self.section.lowercased().contains(keyword: keyword.lowercased()) || self.subSection.lowercased().contains(keyword: keyword.lowercased())
    }
}

extension Flavor: Presentable {
    var displayName: String {
        return section + "- " + subSection
    }
}
