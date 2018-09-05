//
//  Variety.swift
//  Coffee
//
//  Created by Khanh T Pham on 9/4/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

class Variety {
    private var reference: DocumentReference!
    var documentID: String {
        return reference.documentID
    }
    var name: String
    var detail: String
    init(name: String, detail: String = "") {
        self.name = name
        self.detail = detail
    }
}
