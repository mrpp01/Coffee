//
//  Brand.swift
//  Coffee
//
//  Created by Khanh T Pham on 9/4/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Brand {
    private var reference: DocumentReference!
    var documentID: String {
        return reference.documentID
    }
    var name: String
    var address: String
    init(name: String, address: String = "") {
        self.name = name
        self.address = address
    }
}

