//
//  Origin.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/16/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Origin: FirestoreModel {
    
    internal var reference: DocumentReference?
    var documentID: String? {
        return reference?.documentID
    }
    var collectionPath: String = "origins"
    
    func notifyObserver(message: String) {}
    
    func saveTo(database: Firestore) {
        print("Orgin.saveTo(database: Firestore) is not implemented")
    }
    
    let country: String
    var region: String?
    var detail: String = ""
    
    var dictionary: [String: Any] {
        return [Field.country.key: self.country, Field.detail.key: self.detail]
    }
    
    init(country: String, region: String? = nil, detail: String = "") {
        self.country = country
        self.region = region
        self.detail = ""
    }
    
    required init?(from document: DocumentSnapshot) {
        
        guard let dictionary = document.data(), let country = dictionary[Field.country.key] as? String else {
            print("Cannot create origin from snapshot")
            return nil
        }
    
        self.country = country
        self.region = dictionary[Field.region.key] as? String
        self.detail = dictionary[Field.detail.key] as? String ?? ""
        
    }
    
    enum Field: String {
        case country = "country"
        case region = "region"
        case detail = "detail"
        
        var key: String {
            return self.rawValue
        }
    }
}

extension Origin: Searchable {
    func contains(keyword: String) -> Bool {
        return self.country.lowercased().contains(keyword.lowercased())
    }
}

extension Origin: Presentable {
    var displayName: String { return country }
}

