//
//  Bag.swift
//  Coffee
//
//  Created by Khanh T. Pham on 6/4/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
extension Notification.Name {
    static let BagDidChange = Notification.Name("Bag Did Change")
}


class Bag {
    internal var reference: DocumentReference?
    
    var documentID: String? {
        return reference?.documentID
    }
    
    private var coffee: Coffee
    private var coffeeDocumentID: String { return coffee.documentID }
    private var producer: String?
    private var farm: Farm?
    private var farmDocumentID: String? { return farm?.documentID }
    private var altitude: Int?
    private var process: String?
    
    private var brand: Brand?
    private var brandDocumentID: String? {
        return brand?.documentID
    }
    
    private var roaster: Roaster?
    private var roasterDocumentID: String? {
        return roaster?.documentID
    }
    private var roast: Roast?
    private var roastDate: Date?
    
    private var price: Double?
    private var weight: Int?
    
    private var flavors: [Flavor] = [Flavor]()
    
    init(coffee: Coffee, producer: String? = nil, farm: Farm? = nil, altitude: Int? = nil, process: String? = nil, brand: Brand? = nil, roaster: Roaster? = nil, roast: Roast = .NA, roastDate: Date? = nil, price: Double? = nil, weight: Int? = nil) {
        
        self.coffee = coffee
        self.producer = producer
        self.farm = farm
        self.altitude = altitude
        self.process = process
        self.brand = brand
        
        self.roaster = roaster
        self.roast = roast
        self.roastDate = roastDate
        
        self.price = price
        self.weight = weight

    }
    
    required init?(from snapshot: DocumentSnapshot) {
        return nil
    }
    
}

extension Bag: FirestoreModel {
    
    var collectionPath: String { return "bags" }
    
    var dictionary: [String : Any] { return [String: Any]() }
    
    enum Field: String {
        case documentID = "documentID"
        
        case displayName = "displayName"
        
        case coffee = "coffee"
        case coffeeDocumentID = "coffeeDocumentID"
        case producer = "producer"
        case farm = "farm"
        case farmDocumentID = "farmDocumentID"
        case altitude = "altitude"
        case process = "process"
        
        case brand = "brand"
        case brandDocumentID = "brandDocumentID"
        
        case roaster = "roaster"
        case roasterDocumentID = "roasterDocumentID"
        case roast = "roast"
        case roastDate = "roastDate"
        
        case price = "price"
        case weight = "weight"
        
        case flavors = "flavors"
        
        case origin = "origin"
        case variety = "variety"
        
        var key: String { return self.rawValue }
        
        var dictionaryFields: [Field] {
            return [ .coffeeDocumentID, .producer, .farmDocumentID,
                     .altitude, .process, .brandDocumentID,
                     .roasterDocumentID, .roast, .roastDate,
                     .price, .weight, .flavors ]
        }
    }
    
    func value(for field: Field) -> Any {
        switch field {
        case .coffee: return self.coffee
        case .coffeeDocumentID: return self.coffeeDocumentID
        case .producer: return self.producer as Any
        case .farm: return self.farm as Any
        case .farmDocumentID: return self.farmDocumentID as Any
        case .altitude: return self.altitude as Any
        case .process: return self.process as Any
            
        case .brand: return self.brand as Any
        case .brandDocumentID: return self.brandDocumentID as Any
            
        case .roaster: return self.roaster as Any
        case .roasterDocumentID: return self.roasterDocumentID as Any
        case .roast: return self.roast as Any
        case .roastDate: return self.roastDate as Any
            
        case .price: return self.price as Any
        case .weight: return self.weight as Any
            
        case .flavors: return self.flavors
        default:
            return print("value for field: '\(field.key)' is unavailable")
        }
    }
    
    func stringValue(for field: Field) -> String? {
        switch field {
        case .displayName: return self.displayName
        case .origin: return self.coffee.origin.displayName
        case .variety: return self.coffee.variety?.name
        case .producer: return self.producer?.displayName
        case .farm: return self.farm?.name
        case .altitude: return altitude != nil ? String(altitude!) : nil
        case  .process: return self.process
        case .brand: return self.brand?.name
        case .roaster: return self.roaster?.name
        case .roastDate: return stringValueFor(date: roastDate)
        case .roast: return roast?.rawValue
        case .price: return price != nil ? String(price!) : nil
        case .weight: return weight != nil ? String(weight!) : nil
        default:
            print("value for field: '\(field.rawValue)' is unavailable")
            return nil
        }
    }
    
    func stringValueFor(date: Date?) -> String {
        return ""
    }
    
    func notifyObserver(message: String) {
    }
    
    func saveTo(database: Firestore) {
    }
}

extension Bag: Searchable {
    
//    var displayName: String { return self.coffee.origin.displayName }
    
    func contains(keyword: String) -> Bool {
        return self.displayName.lowercased().contains(keyword.lowercased())
    }
}

extension Bag: Presentable {
    var displayName: String { return self.coffee.origin.displayName }
}
