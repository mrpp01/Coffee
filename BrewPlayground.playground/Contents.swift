//: Playground - noun: a place where people can play

import UIKit
import Foundation

class Use {
    
    //MARK: Properties
    var purpose: Purpose
    var bagID: String
    var dose: Double
    var note: String
    var rating: Int
    var method: Method
    var grind: Grind?
    var equipment: Equipment
    var info: [String: Any]{
        return [ Key.rating: rating,
                 Key.method: method.rawValue,
                 Key.Grind.size: grind!.size,
                 Key.Grind.grinder: grind!.grinder,
                 Key.Grind.note: grind!.note,
                 Key.equipment: equipment.rawValue,
                 Key.bagID: bagID]
    }
    
    //MARK: Initialization

    required init(for purpose: Purpose, with info: [String: Any]) {
        self.purpose = purpose
        self.bagID = (info[Key.bagID] != nil) ? info[Key.bagID]! as! String : ""
        self.dose = (info[Key.dose] != nil) ? info[Key.dose]! as! Double : 0.0
        self.note = (info[Key.note] != nil) ? info[Key.note]! as! String : ""
        self.rating = (info[Key.rating] != nil) ? info[Key.rating]! as! Int : 0
        self.method = .NA
        self.equipment = .NA
    }
    
    class func useFor(_ purpose: Purpose, with info: [String: Any]) -> Use {
        var useType: Use.Type

        switch purpose {
        case .Brew: useType = Brew.self
        case .Trash: useType = Trash.self
        case .Gift: useType = Gift.self
        }

        return useType.init(for: purpose, with: info)
    }
}
extension Use {
    enum Method: String {
        case Filter = "Filter"
        case Espresso = "Espresso"
        case NA = "N/A"
    }
    
    enum Equipment: String {
        case AeroPress = "AeroPress"
        case V6001 = "V60 (01)"
        case V6002 = "V60 {02)"
        case Chemex3 = "Chemex (3-Cup)"
        case Chemex6 = "Chemex (6-Cup)"
        case Chemex8 = "Chemex (8-Cup)"
        case KalitaWave155 = "Kalita Wave (155)"
        case KalitaWave185 = "KalitaWave (185)"
        case Gino = "Gino"
        case Kone = "Kone"
        case CleverDripper = "Clever Dripper"
        case Dragon = "Dragon"
        case FrenchPress = "French Press"
        case ColdBrew = "Cold Brew"
        case Cupping = "Cupping"
        case Other = "Other"
        case NA = "N/A"
    }
    
    struct Key {
        static let rating = "rating"
        static let method = "method"
        static let grind = "grind"
        static let equipment = "equipment"
        static let bagID = "bagID"
        static let dose = "dose"
        static let note = "note"
        static let collection = "brews"
        struct Grind {
            static let size = "grind.size"
            static let grinder = "grind.grinder"
            static let note = "grind.note"
        }
    }
    
    struct Grind {
        var size: Int? = nil
        var grinder: String
        var note: String
    }
    
    enum Purpose: String {
        case Brew = "Brew"
        case Trash = "Trash"
        case Gift = "Gift"
    }
}

class Brew: Use {
    required init(for purpose: Purpose, with info: [String : Any]) {
        super.init(for: purpose, with: info)
        //MARK: Create grinder setting
        if let equipmentInfo = info[Key.equipment], let equipmentString = equipmentInfo as? String, let equipmentType = Equipment(rawValue: equipmentString) {
         self.equipment = equipmentType
        }
        if let methodInfo = info[Key.method], let methodString = methodInfo as? String, let methodType = Method(rawValue: methodString) {
            self.method = methodType
        }
        
    }
}
class Trash: Use {
    required init(for purpose: Purpose, with info: [String : Any]) {
        super.init(for: purpose, with: info)
    }
}
class Gift: Use {
    required init(for purpose: Purpose, with info: [String : Any]) {
        super.init(for: purpose, with: info)
    }
}
