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
    
    internal var reference: DocumentReference?
    var documentID: String? {
        return reference?.documentID
    }
    var bagDocumentID: String?
    var bag: Bag?
    
    var method: Method
    
    var recipeDocumentID: String?
    var recipe: Recipe?
    
    var flavors: [Flavor]
    
    var note: String
    var rating: Int?
    
    //MARK: Initialization as new Brew
    init(bag: Bag, recipe: Recipe?, rating: Int?, flavors: [Flavor], method: Method, note: String ) {
        self.recipe = recipe
        self.rating = rating
        self.flavors = flavors
        self.method = method
        self.note = note
        self.method = method
    }
    
    
    init(with bagDocumentID: String, and dictionary: [String: Any]) {
        //        fatalError("Brew Initialization need tto be implemented")
        self.bagDocumentID = bagDocumentID
        self.note = dictionary[Key.note] as? String ?? ""
        self.rating = dictionary[Key.rating] as? Int
        
        
        self.method = dictionary[Key.method] != nil ? Method(rawValue: dictionary[Key.method] as! String)! : .NA
        self.flavors = [Flavor]()
    }
    
    required convenience init?(from snapshot: DocumentSnapshot) {
        
        guard let dictionary = snapshot.data() else {
            fatalError("Failed to init brew from snapshot")
        }
        self.init(with: snapshot.documentID, and: dictionary)
        
        self.reference = snapshot.reference
        
    }
    
    
    class func createBrewData(with bagDocumentID: String, and dictionary: [String: Any]) -> [String: Any] {
        return Brew(with: bagDocumentID, and: dictionary).dictionary
    }
}

extension Brew {
    
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
        static let note = "note"
        static let rating = "rating"
        static let method = "method"
    }
}

extension Brew: FirestoreModel {
    
    
    var dictionary: [String: Any]{
        return [ Key.bagDocumentID: self.bagDocumentID as Any,
                 Key.note: self.note,
                 Key.rating: self.rating as Any,
                 Key.method: self.method.rawValue
        ]
    }
    
    var collectionPath: String {
        return "brews"
    }
    
    enum Field: String {
        
        case bagDocumentID = "bagDocumentID"
        case bag = "bag"
        case method = "method"
        case recipeDocumentID = "recipeDocumentID"
        case recipe = "recipe"
        case note = "note"
        case flavors = "flavors"
        case rating = "rating"
        
        static var dictionaryFields: [Field] {
            return [.bagDocumentID, .method, .recipeDocumentID , .note, .flavors, .rating]
        }
    }

    func valueFor(field: Field) -> Any {
        switch field {
        case .bagDocumentID: return self.bagDocumentID as Any
        case .bag: return bag as Any
        case .method: return method
        case .recipeDocumentID: return recipeDocumentID as Any
        case .recipe: return recipe as Any
        case .note: return note
        case .flavors: return flavors
        case .rating: return rating as Any
            
        }
    }
    
    func stringValueFor(field: Field) -> String {
        switch field {
        case .bagDocumentID: return self.bagDocumentID ?? ""
        case .bag: return bag?.displayName ?? "-"
        case .method: return method.rawValue
        case .recipeDocumentID: return recipeDocumentID ?? ""
        case .recipe: return recipe?.name ?? "-"
        case .note: return note
        default: return ""
        }
    }
    
    func setValue(value: Any, for field: Field) {
        
    }
    
    func saveTo(database: Firestore) {
    
    }

    func notifyObserver(message: String) {
        
    }
    
}
