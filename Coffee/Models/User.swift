//
//  User.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/2/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.

import Foundation
import Firebase

class User {
    
    var bags: [Bag]
    var origins: [Origin] = [Origin]()
    private(set) var brews: [Brew]
    private(set) var activities: [Activity]
    
    private(set) var database: Firestore! 
    
    private init() {
        self.bags = [Bag]()
        self.brews = [Brew]()
        self.activities = [Activity]()
        self.database = Firestore.firestore()
    }
    
    func createSampleBag() -> Bag {
        
        let coffee = Coffee(origin: .init(country: "Vietnam", region: "Da Lat", detail: ""), variety: Variety(name: "Catimor", detail: ""))
        let brand = Brand(name: "The Workshop", address: "Hochiminh City")
        let roaster = Roaster(name: "The Workshop")
        return Bag(coffee: coffee, producer: "Hung",
            farm: Farm(name: "LaViet", address: "Dalat"),
            altitude: 1500,
            process: "Dry",
            brand: brand,
            roaster: roaster,
            roast: .Light,
            roastDate: Date(),
            price: 20, weight: 200)
    }
    
    class func getUser() -> User {
        let user = User()
        user.bags.append(user.createSampleBag())
        return user
    }
    
    func save(object: FirestoreModel) {
        object.saveTo(database: database)
    }
}

extension User {
    struct CollectionKeys {
        static let bags = "bags"
        static let brews = "brews"
        static let activities = "activities"
        static let origins = "origins"
        static let recipes = "recipes"
    }
}
