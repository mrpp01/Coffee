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
    
    class func getUser() -> User {
        return User()
    }
    
    //MARK: Create Bag
    func createBag(from dictionary: [String: Any]) {
        let newBagReference = getNewBagReference()
        let newActivityReference = getNewActivityReference()
        let newBag = Bag(from: dictionary)
        let newActivity = Activity(type: .CreateBag, referenceDocumentID: newBagReference.documentID)
        
        let batch = database.batch()
        batch.setData(newBag.dictionary, forDocument: newBagReference)
        batch.setData(newActivity.dictionary, forDocument: newActivityReference)
        
        batch.commit { (error) in
            if let error = error { print("Batch write failed with error: \(error)")
            } else { print("Batch write succeeded") }
        }
    }
    
    //MARK: Create Brew
    /**
     Create a brew instance
     In case a bag was selected, add brew reference's document ID to the bag and call update bag statistic
     If no bag was selected, add brew reference's document ID to "Others" bag
     */
    func createBrew(with dictionary: [String: Any], and selectedBag: Bag) {
        
        //TODO: Handle case when "Others" bag does not exist
        //TODO: Add activity
        let brewReference = getNewBrewReference()
        let brew = Brew(with: selectedBag.reference.documentID, and: dictionary)
        
        let newActivityReference = getNewActivityReference()
        let newActivity = Activity(type: .CreateBrew, referenceDocumentID: brewReference.documentID)
        
        //Check to see if bag exist in array. If not, throw fatal error.
        //TODO: In future, need to implement checking bag existence on Firestore instead
        let updatedBagData = selectedBag.add(brew)
        
        //Batch write to Firebase
        let batch = database.batch()

        batch.setData(brew.dictionary, forDocument: brewReference)
       // batch.setData(updatedBagData, forDocument: selectedBag.reference)
        batch.setData(updatedBagData, forDocument: selectedBag.reference, merge: true)
        batch.setData(newActivity.dictionary, forDocument: newActivityReference)
        
        batch.commit { (error) in
            if let error = error { print("Batch write failed with error: \(error)")
            } else { print("Batch write succeeded") }
        }
    }
    
    func createBrew(with dictionary: [String: Any]) {
        
        //TODO: Handle case when "Others" bag does not exist
        //TODO: Add activity
        let brewReference = getNewBrewReference()
        let brew = Brew(with: "Others", and: dictionary)
        
        let newActivityReference = getNewActivityReference()
        let newActivity = Activity(type: .CreateBrew, referenceDocumentID: brewReference.documentID)
        
        //Batch write to Firebase
        let batch = database.batch()
        
        batch.setData(brew.dictionary, forDocument: brewReference)
        batch.setData(newActivity.dictionary, forDocument: newActivityReference)
        
        batch.commit { (error) in
            if let error = error { print("Batch write failed with error: \(error)")
            } else { print("Batch write succeeded") }
        }
    }
    
    private func getBagReference(with documentID: String) -> DocumentReference {
        return database.collection(CollectionKeys.bags).document(documentID)
    }
    
    private func getBrewReference(with documentID: String) -> DocumentReference {
        return database.collection(CollectionKeys.brews).document(documentID)
    }
    
    private func getActivityReference(with documentID: String) -> DocumentReference {
        return database.collection(CollectionKeys.activities).document(documentID)
    }
    
    private func getNewBagReference() -> DocumentReference {
        return database.collection(CollectionKeys.bags).document()
    }
    
    private func getNewBrewReference() -> DocumentReference {
        return database.collection(CollectionKeys.brews).document()
    }
    
    private func getNewActivityReference() -> DocumentReference {
        return database.collection(CollectionKeys.activities).document()
    }
}

extension User {
    struct CollectionKeys {
        static let bags = "bags"
        static let brews = "brews"
        static let activities = "activities"
        static let origins = "origins"
    }
}
