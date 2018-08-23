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
    
    private(set) var reference: DocumentReference!
    
    private(set) var brandName: String
    private(set) var producerInfo: String
    private(set) var roaster: String
    private(set) var roasterNotes: String
    
    private(set) var roastDate: Date
    private(set) var weight: Double
    var usedWeight: Double { return  brewWeight + giftWeight + trashWeight }
    
    var currentWeight: Double {
        return weight - usedWeight
    }
    
    var brewWeight: Double = 0
    var giftWeight: Double = 0
    var trashWeight: Double = 0
    
    var daysOld: Int {
        let calendar = Calendar.current
        
        let date = calendar.startOfDay(for: roastDate)
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date, to: today)
        
        return components.day!
    }
    
    var status: String {
        switch daysOld {
        case 0..<2: return "Newly Roasted"
        case 2...6: return "New"
        case 7...13: return "Good"
        case 14...27: return "Older"
        case 28...: return "Stale"
        default: return "N/A"
        }
    }
    
    
    private var process: String
    private var isGift: Bool
    private var recommendedBy: String
    private var maxRating: Int
    
    private var beanReferences: [String: String]
    private var brewReferences: [String]
    private var trashReferences: [String]
    private var giftReferences: [String]
    private var photoReferences: [String]
    
    var dictionary: [String: Any] {
        return [
            Key.brandName: self.brandName,
            Key.roaster: self.roaster,
            Key.roastDate: self.roastDate,
            Key.weight: self.weight,
            Key.process: self.process,
            
            Key.producerInfo: self.producerInfo,
            Key.roasterNotes: self.roasterNotes,
            Key.isGift: self.isGift,
            Key.recommendedBy: self.recommendedBy,
        
            Key.beanReferences: self.beanReferences,
            Key.photoReferences: self.photoReferences,
            Key.trashReferences: self.trashReferences,
            Key.giftReferences: self.giftReferences,
            Key.brewReferences: self.brewReferences,
            Key.brewWeight: self.brewWeight,
            Key.giftWeight: self.giftWeight,
            Key.trashWeight: self.trashWeight,
        
            Key.maxRating: self.maxRating,
        ]
    }
    
    private(set) var brewStatistic: [String: Int] = [String: Int]()
    
    //MARK: Initialization
    init(from dictionary: [String: Any]) {
        
        self.brandName = dictionary[Bag.Key.brandName] as? String ?? DefaultValue.brandName
        self.roaster = dictionary[Bag.Key.roaster] as? String ?? DefaultValue.roaster
        self.roastDate = dictionary[Bag.Key.roastDate] as? Date ?? DefaultValue.roastDate
        self.weight = dictionary[Bag.Key.weight] as? Double ?? DefaultValue.weight
        self.process = dictionary[Bag.Key.process] as? String ?? DefaultValue.process
        self.beanReferences = dictionary[Bag.Key.beanReferences] as? [String: String] ?? DefaultValue.beanReferences
        self.producerInfo = dictionary[Bag.Key.producerInfo] as? String ?? DefaultValue.producerInfo
        self.roasterNotes = dictionary[Bag.Key.roasterNotes] as? String ?? DefaultValue.roasterNotes
        self.isGift = dictionary[Bag.Key.isGift] as? Bool ?? DefaultValue.isGift
        self.recommendedBy = dictionary[Bag.Key.recommendedBy] as? String ?? DefaultValue.recommendedBy
        self.brewWeight = dictionary[Bag.Key.brewWeight] as? Double ?? DefaultValue.brewWeight
        self.giftWeight = dictionary[Bag.Key.giftWeight] as? Double ?? DefaultValue.giftWeight
        self.trashWeight = dictionary[Bag.Key.trashWeight] as? Double ?? DefaultValue.trashWeight
        self.maxRating = dictionary[Bag.Key.maxRating] as? Int ?? DefaultValue.maxRating
        
        self.brewReferences = dictionary[Bag.Key.brewReferences] as? [String] ?? DefaultValue.brewReferences
        self.trashReferences = dictionary[Bag.Key.trashReferences] as? [String] ?? DefaultValue.trashReferences
        self.giftReferences = dictionary[Bag.Key.giftReferences] as? [String] ?? DefaultValue.giftReferences
        self.photoReferences = dictionary[Bag.Key.photoReferences] as? [String] ?? DefaultValue.photoReferences
        
    }
    //TODO: Rewrite the logic to make the init failable
    //MARK: Initialization from Snapshot
    /*
     Verify snapshot data is up-to-date with the object structure
     Return object if data is valid
     Update server data if snapshot data is not up-to-date with object struture
     */
    private init?(from snapshot: DocumentSnapshot) {
        
        guard let dictionary = snapshot.data() else {
            fatalError("Snapshot data is nil")
        }
        self.reference = snapshot.reference
        var needToUpdateFirebaseData = false
        
        if let brandName = dictionary[Bag.Key.brandName] as? String {
            self.brandName = brandName
        } else {
            self.brandName = DefaultValue.brandName
            needToUpdateFirebaseData = true
        }
        
        if let roaster = dictionary[Bag.Key.roaster] as? String {
            self.roaster = roaster
        } else {
            self.roaster = DefaultValue.roaster
            needToUpdateFirebaseData = true
        }
        //TODO: Fix timestamp error
        if let timestamp = dictionary[Bag.Key.roastDate] as? Timestamp{
            self.roastDate = (timestamp).dateValue()
        } else {
            self.roastDate = DefaultValue.roastDate
            needToUpdateFirebaseData = true
        }
        if let weight = dictionary[Bag.Key.weight] as? Double {
            self.weight = weight
        } else {
            self.weight = DefaultValue.weight
            needToUpdateFirebaseData = true
        }
        if let process = dictionary[Bag.Key.process] as? String {
            self.process = process
        } else {
            self.process = DefaultValue.process
            needToUpdateFirebaseData = true
        }
        
        if let producerInfo = dictionary[Bag.Key.producerInfo] as? String {
            self.producerInfo = producerInfo
        } else {
            self.producerInfo = DefaultValue.producerInfo
            needToUpdateFirebaseData = true
        }
        
        if let roasterNotes = dictionary[Bag.Key.roasterNotes] as? String {
            self.roasterNotes = roasterNotes
        } else {
            self.roasterNotes = DefaultValue.roasterNotes
            needToUpdateFirebaseData = true
        }
        
        if let isGift = dictionary[Bag.Key.isGift] as? Bool {
            self.isGift = isGift
        } else {
            self.isGift = DefaultValue.isGift
            needToUpdateFirebaseData = true
        }
        
        if let recommendedBy = dictionary[Bag.Key.recommendedBy] as? String {
            self.recommendedBy = recommendedBy
        } else {
            self.recommendedBy = DefaultValue.recommendedBy
            needToUpdateFirebaseData = true
        }
        
        if let brewWeight = dictionary[Bag.Key.brewWeight] as? Double {
            self.brewWeight = brewWeight
        } else {
            self.brewWeight = DefaultValue.brewWeight
            needToUpdateFirebaseData = true
        }
        
        if let giftWeight = dictionary[Bag.Key.giftWeight] as? Double {
            self.giftWeight = giftWeight
        } else {
            self.giftWeight = DefaultValue.giftWeight
            needToUpdateFirebaseData = true
        }
        if let trashWeight = dictionary[Bag.Key.trashWeight] as? Double {
            self.trashWeight = trashWeight
        } else {
            self.trashWeight = DefaultValue.trashWeight
            needToUpdateFirebaseData = true
        }
        
        if let maxRating = dictionary[Bag.Key.maxRating] as? Int {
            self.maxRating = maxRating
        } else {
            self.maxRating = DefaultValue.maxRating
            needToUpdateFirebaseData = true
        }
        
        if let beanReferences = dictionary[Bag.Key.beanReferences] as? [String: String] {
            self.beanReferences = beanReferences
        } else {
            self.beanReferences = DefaultValue.beanReferences
            needToUpdateFirebaseData = true
        }
        
        if let brewReferences = dictionary[Bag.Key.brewReferences] as? [String] {
            self.brewReferences = brewReferences
        } else {
            self.brewReferences = DefaultValue.brewReferences
            needToUpdateFirebaseData = true
        }
        
        if let trashReferences = dictionary[Bag.Key.trashReferences] as? [String] {
            self.trashReferences = trashReferences
        } else {
            self.trashReferences = DefaultValue.trashReferences
            needToUpdateFirebaseData = true
        }
        
        if let giftReferences = dictionary[Bag.Key.giftReferences] as? [String] {
            self.giftReferences = giftReferences
        } else {
            self.giftReferences = DefaultValue.giftReferences
            needToUpdateFirebaseData = true
        }
        
        if let photoReferences = dictionary[Bag.Key.photoReferences] as? [String] {
            self.photoReferences = photoReferences
        } else {
            self.photoReferences = DefaultValue.photoReferences
            needToUpdateFirebaseData = true
        }
        
        if needToUpdateFirebaseData {
            print("Need to update bag with reference: \(self.reference.documentID)")
        }
    }
    
    class func createBag(from snapshot: DocumentSnapshot) -> Bag? {
        //TODO: Implement a failable initialization from snapshot
        return Bag(from: snapshot)
    }
}

extension Bag {
    static let roasterArray = ["Bosgarus", "La Viet", "KOK",
                               "Namusairo", "coffee libre", "coffee center"]
    static let brandNameArray = ["Bosgarus", "La Viet", "KOK",
                                 "Namusairo", "coffee libre", "coffee center"]
    static let processArray = ["Natural", "Washed"]
    
    private struct DefaultValue {
        static let brandName: String = "N/A"
        static let roaster: String = "N/A"
        static let roastDate = Date()
        static let weight: Double = 200
        static let beanReferences: [String: String] = [String: String]()
        static let process = "N/A"
        static let producerInfo: String = "N/A"
        static let roasterNotes: String = "N/A"
        static let isGift: Bool = false
        static let recommendedBy: String = "N/A"
        
        static let brewWeight: Double = 0
        static let giftWeight: Double = 0
        static let trashWeight: Double = 0
        static let maxRating: Int = 0
        
        static let photoReferences: [String] = [String]()
        static let brewReferences = [String]()
        static let trashReferences = [String]()
        static let giftReferences = [String]()
    }
    
    struct Key {
        
        static let documentID = "documentID"
        
        static let brandName = "brandName"
        static let roaster = "roaster"
        static let roastDate = "roastDate"
        static let weight = "weight"
        static let process = "process"
        static let producerInfo = "producerInfo"
        static let roasterNotes = "roasterNotes"
        static let isGift = "isGift"
        static let recommendedBy = "recommendedBy"
        
        static let beanReferences = "beanReferences"
        static let photoReferences = "photoReferences"
        static let trashReferences = "trashReferences"
        static let giftReferences = "giftReferences"
        static let brewReferences = "brewReferences"
        static let brewWeight = "brewWeight"
        static let giftWeight = "giftWeight"
        static let trashWeight = "trashWeight"
        
        static let maxRating = "maxRating"
        
        static let brewStatistic = "brewStatistic"
    }
}

//MARK: Notification
extension Bag {
    
    struct Message {
        static let NotificationEventKey = "NotificationEventKey"
        static let didUpdateWeight = "didUpdateWeight"
    }
    
    func notifyObserver(message: String, with info: [AnyHashable: Any] = [:]) {
        var userInfo = info
        userInfo[Message.NotificationEventKey] = message
        let notification = Notification(name: .BagDidChange, object: self, userInfo: userInfo)
        let center = NotificationCenter.default
        center.post(notification)
        
    }
}

extension Bag {
    func add(_ brew: Brew) -> [String: Any] {
        //MARK: Update statistic
        var output = [String: Any]()
        output[Key.brewWeight] = self.brewWeight + brew.dose
        var currentStat = brewStatistic
        currentStat[brew.method.rawValue] = brewStatistic[brew.method.rawValue] != nil ? brewStatistic[brew.method.rawValue]! + 1 : 1
        output[Key.brewStatistic] = currentStat
        
        return output
    }
    
    func remove(_ brew: Brew) {
        fatalError("No implementation")
    }
}



class OtherBag: Bag {
    static let documentID: String = "Others"
}
