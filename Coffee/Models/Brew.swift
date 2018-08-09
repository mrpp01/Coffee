//
//  Brew.swift
//  Coffee
//
//  Created by Khanh T. Pham on 6/4/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Brew {
    
    //MARK: Properties
    
    private(set) var reference: DocumentReference!
    var bagDocumentID: String
    var grinderDocumentID: String
    var grindSize: Int
    var dose: Double
    var note: String
    var rating: Int
    var method: Method
    var equipment: Equipment
    
    var dictionary: [String: Any]{
        return [ Key.bagDocumentID: self.bagDocumentID,
                 Key.grinderDocumentID: self.grinderDocumentID,
                 Key.grindSize: self.grindSize,
                 Key.dose: self.dose,
                 Key.note: self.note,
                 Key.rating: self.rating,
                 Key.method: self.method.rawValue,
                 Key.equipment: self.equipment.rawValue
        ]
    }
    
    //MARK: Initialization as new Brew
    init(with bagDocumentID: String, and dictionary: [String: Any]) {
        //        fatalError("Brew Initialization need tto be implemented")
        self.bagDocumentID = bagDocumentID
        self.grinderDocumentID = dictionary[Key.grinderDocumentID] as? String ?? DefaultValue.grinderDocumentID
        self.grindSize = dictionary[Key.grindSize] as? Int ?? DefaultValue.grindSize
        self.dose = dictionary[Key.dose] as? Double ?? DefaultValue.dose
        self.note = dictionary[Key.note] as? String ?? DefaultValue.note
        self.rating = dictionary[Key.rating] as? Int  ?? DefaultValue.rating
        self.method = dictionary[Key.method] != nil ? Method(rawValue: dictionary[Key.method] as! String)! : DefaultValue.method
        if dictionary[Key.method] != nil, let method = Method(rawValue: dictionary[Key.method] as! String) {
            self.method = method
        } else { self.method = DefaultValue.method }
        if dictionary[Key.equipment] != nil, let equipment = Equipment(rawValue: dictionary[Key.equipment] as! String) {
            self.equipment = equipment
        } else { self.equipment = DefaultValue.equipment }
    }
    
    init?(with snapshot: DocumentSnapshot) {
        guard let dictionary = snapshot.data() else {
            fatalError("Failed to init brew from snapshot")
        }
        self.reference = snapshot.reference
        var needToUpdateFirebaseData = false

        if let bagDocumentID = dictionary[Key.bagDocumentID] as? String { self.bagDocumentID = bagDocumentID
        } else {
            self.bagDocumentID = DefaultValue.bagDocumentID
            needToUpdateFirebaseData = true
        }
        
        if let grinderDocumentID = dictionary[Key.grinderDocumentID] as? String { self.grinderDocumentID = grinderDocumentID
        } else {
            self.grinderDocumentID = DefaultValue.grinderDocumentID
            needToUpdateFirebaseData = true
        }
        if let grindSize = dictionary[Key.grindSize] as? Int { self.grindSize = grindSize
        } else {
            self.grindSize = DefaultValue.grindSize
            needToUpdateFirebaseData = true
        }
        if let dose = dictionary[Key.dose] as? Double { self.dose = dose
        } else {
            self.dose = DefaultValue.dose
            needToUpdateFirebaseData = true
        }
        if let note = dictionary[Key.note] as? String { self.note = note
        } else {
            self.note =  DefaultValue.note
            needToUpdateFirebaseData = true
        }
        self.rating = dictionary[Key.rating] as? Int  ?? DefaultValue.rating
        self.method = dictionary[Key.method] != nil ? Method(rawValue: dictionary[Key.method] as! String)! : DefaultValue.method
        if dictionary[Key.method] != nil, let method = Method(rawValue: dictionary[Key.method] as! String) {
            self.method = method
        } else { self.method = DefaultValue.method }
        if dictionary[Key.equipment] != nil, let equipment = Equipment(rawValue: dictionary[Key.equipment] as! String) {
            self.equipment = equipment
        } else { self.equipment = DefaultValue.equipment }
    }
    
    class func createBrewData(with bagDocumentID: String, and dictionary: [String: Any]) -> [String: Any] {
        return Brew(with: bagDocumentID, and: dictionary).dictionary
    }
}
extension Brew {
    enum Method: String {
        case Filter = "Filter"
        case Espresso = "Espresso"
        case NA = "N/A"
    }
    
    private struct DefaultValue {
        static let bagDocumentID = OtherBag.documentID
        static let grinderDocumentID = OtherGrinder.documentID
        static let grindSize: Int = 0
        static let dose: Double = 20
        static let note: String = "N/A"
        static let rating: Int = 0
        static let method: Method = .NA
        static let equipment: Equipment = .NA
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
        static let bagDocumentID = "bagDocumentID"
        static let grinderDocumentID = "grinderDocumentID"
        static let grindSize = "grindSize"
        static let dose = "dose"
        static let note = "note"
        static let rating = "rating"
        static let method = "method"
        static let equipment = "equipment"
    }
}
