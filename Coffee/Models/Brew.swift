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
    var brewType: BrewType
    var method: Method
    
    var dictionary: [String: Any]{
        return [ Key.bagDocumentID: self.bagDocumentID,
                 Key.grinderDocumentID: self.grinderDocumentID,
                 Key.grindSize: self.grindSize,
                 Key.dose: self.dose,
                 Key.note: self.note,
                 Key.rating: self.rating,
                 Key.brewType: self.brewType.rawValue,
                 Key.method: self.method.rawValue
        ]
    }
    
    //MARK: Initialization as new Brew
    init(with bagDocumentID: String, and dictionary: [String: Any]) {
        //        fatalError("Brew Initialization need tto be implemented")
        self.bagDocumentID = bagDocumentID
        self.grinderDocumentID = dictionary[Key.grinderDocumentID] as? String ?? DefaultValue.grinderDocumentID
        self.grindSize = dictionary[Key.grindSize] as? Int ?? DefaultValue.grindSize
        self.dose = dictionary[Key.dose] as? Double ?? DefaultValue.dose
        print("Dose in init: \(self.dose)")
        self.note = dictionary[Key.note] as? String ?? DefaultValue.note
        self.rating = dictionary[Key.rating] as? Int  ?? DefaultValue.rating
        self.brewType = dictionary[Key.brewType] != nil ? BrewType(rawValue: dictionary[Key.brewType] as! String)! : DefaultValue.brewType
        if dictionary[Key.brewType] != nil, let brewType = BrewType(rawValue: dictionary[Key.brewType] as! String) {
            self.brewType = brewType
        } else { self.brewType = DefaultValue.brewType }
        if dictionary[Key.method] != nil, let method = Method(rawValue: dictionary[Key.method] as! String) {
            self.method = method
        } else { self.method = DefaultValue.method }
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
        self.brewType = dictionary[Key.brewType] != nil ? BrewType(rawValue: dictionary[Key.brewType] as! String)! : DefaultValue.brewType
        if dictionary[Key.brewType] != nil, let brewType = BrewType(rawValue: dictionary[Key.brewType] as! String) {
            self.brewType = brewType
        } else { self.brewType = DefaultValue.brewType }
        if dictionary[Key.method] != nil, let method = Method(rawValue: dictionary[Key.method] as! String) {
            self.method = method
        } else { self.method = DefaultValue.method }
    }
    
    class func createBrewData(with bagDocumentID: String, and dictionary: [String: Any]) -> [String: Any] {
        return Brew(with: bagDocumentID, and: dictionary).dictionary
    }
}
extension Brew {
    enum BrewType: String {
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
        static let brewType: BrewType = .NA
        static let method: Method = .NA
    }
    
    enum Method: String, Searchable {
        
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
        
        var displayName: String {
            return self.rawValue
        }
        
        static var all: [Method] {
            return [ .AeroPress, .V6001, .V6002,
                     .Chemex3, .Chemex6, .Chemex8,
                     .KalitaWave155, .KalitaWave185, .Gino,
                     .Kone, .CleverDripper, .Dragon,
                     .FrenchPress, .ColdBrew, .Cupping,
                     .Other, .NA,
            ]
        }
        
        func contains(keyword: String) -> Bool {
            return self.rawValue.lowercased().contains(keyword: keyword.lowercased())
        }
        
    }
    
    struct Key {
        static let bagDocumentID = "bagDocumentID"
        static let grinderDocumentID = "grinderDocumentID"
        static let grindSize = "grindSize"
        static let dose = "dose"
        static let note = "note"
        static let rating = "rating"
        static let brewType = "brewType"
        static let method = "method"
    }
}
