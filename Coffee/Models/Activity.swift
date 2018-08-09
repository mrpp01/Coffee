//
//  Activity.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/2/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase
class Activity {
    var reference: DocumentReference!
    var type: ActivityTypes
    var referenceDocumentID: String
    var dictionary: [String: Any] {
        return [Key.type: self.type.rawValue, Key.referenceDocumentID: self.referenceDocumentID]
    }
    
    //MARK: Initialization
    
    init(type: ActivityTypes, referenceDocumentID: String ) {
        
        self.type = type
        self.referenceDocumentID = referenceDocumentID
    }
    
    
    
     init?(from snapshot: DocumentSnapshot) {
        guard let dictionary = snapshot.data() else {
            print("Snapshot Data is not available")
            return nil
        }
        guard let typeRawValue = dictionary[Key.type] as? String, let type = ActivityTypes(rawValue: typeRawValue), let referenceDocumentID = dictionary[Key.referenceDocumentID] as? String else {
            print("Cannot create Activity from \(dictionary)")
            return nil
        }
        self.reference = snapshot.reference
        self.type = type
        self.referenceDocumentID = referenceDocumentID
    }
}

extension Activity {
    enum ActivityTypes: String {
        case CreateBag = "Create Bag"
        case CreateBrew = "Create Brew"
        case Gift = "Grift"
    }
    struct Key {
        static let type = "type"
        static let referenceDocumentID = "referenceDocumentID"
    }
}
