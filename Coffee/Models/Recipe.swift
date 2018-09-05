//
//  Recipe.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/23/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Recipe {
    internal var reference: DocumentReference?
    var documentID: String? {
        return reference?.documentID
    }
    
    var name: String?
    
    var dose: Int
    var water: Int
    var grind: Int?
    var temperature: Int?
    var turbulence: String?
    
    var endTime: Date?
    var yield: Int?
    var tds: Int?
    var extraction: Double?
    
    var note: String
    
    init(name: String? = nil, dose: Int, water: Int, temperature: Int? = nil, grind: Int? = nil, note: String = "") {
        self.dose = dose
        self.water = water
        self.temperature = temperature
        self.grind = grind
        self.note = note
    }
    
    private init?(from dictionary: [String: Any]) {
        guard let dose = dictionary[Field.dose.key] as? Int, let water = dictionary[Field.water.key] as? Int else {
            return nil
        }
        
        self.dose = dose
        self.water = water
        
        self.name = dictionary[Field.name.key] as? String
        self.temperature = dictionary[Field.temperature.key] as? Int
        self.grind = dictionary[Field.grind.key] as? Int
        self.note = dictionary[Field.note.key] as? String ?? ""
        
        
    }
    
    required convenience init?(from documentSnapshot: DocumentSnapshot) {
        guard let dictionary = documentSnapshot.data() else {
            return nil
        }
        self.init(from: dictionary)
//        self.dose = 0
//        self.water = 0
//
//        self.name = dictionary[Field.name.key] as? String
//        self.temperature = dictionary[Field.temperature.key] as? Int
//        self.grind = dictionary[Field.grind.key] as? Int
//        self.note = dictionary[Field.note.key] as? String ?? ""
        self.reference = documentSnapshot.reference
    }
    
    func notifyObserver(message: String) {
        print("Recipe.notifyObserver is not implemented")
        //        let notification = Notification(name: , object: self)
        //        let center = NotificationCenter.default
        //        center.post(notification)
    }
    
}

extension Recipe: FirestoreModel {
    var dictionary: [String: Any] {
        
        var dictionary = [String: Any]()
        
        for field in Field.dictionaryFields {
            dictionary[field.key] = valueFor(field: field)
        }
        
        return dictionary
    }
    
    var collectionPath: String {
        return "recipes"
    }
    
    enum Field: String {
        
        case name = "name"
        
        case dose = "dose"
        case water = "water"
        case grind = "grind"
        case temperature = "temperature"
        case turbulence = "turbulence"
        
        case endTime = "endTime"
        case yield = "yield"
        case tds = "tds"
        case extraction = "extraction"
        
        case note = "note"
        
        var key: String {
            return self.rawValue
        }
        
        static let dictionaryFields: [Field]  = [.name, .dose, .water,
                                                 .grind, .temperature, .turbulence,
                                                 .endTime, .yield, .tds,
                                                 .extraction, .note]
    }
    
    
    func valueFor(field: Field) -> Any {
        switch field {
        case .name: return self.name as Any
        case .dose: return self.dose
        case .water: return self.water
        case .grind: return self.grind as Any
        case .temperature: return self.temperature as Any
        case .turbulence: return self.turbulence as Any
            
        case .endTime: return self.endTime as Any
        case .yield: return self.yield as Any
        case .tds: return self.tds as Any
        case .extraction: return self.extraction as Any
        case .note: return self.note
        }
    }
    
    func saveTo(database: Firestore) {
        
    }
}
