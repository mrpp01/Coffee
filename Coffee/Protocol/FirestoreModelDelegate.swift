//
//  FirestoreModelDelegate.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/29/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreModel {
    var reference: DocumentReference? {get set}
    var documentID: String? {get}
    var collectionPath: String {get}
    var dictionary: [String: Any] {get}
    
    init?(from documentSnapshot: DocumentSnapshot) 
    
    func notifyObserver(message: String)
    func saveTo(database: Firestore)
}

extension FirestoreModel {
    func saveTo(database: Firestore) {}
}

protocol FirestoreModelDelegate {
    func saveToFirestore(object: FirestoreModel) -> Void
    func setData(to collectionPath: String, documentID: String?, documentData: [String: Any])
}

extension User: FirestoreModelDelegate {

    func saveToFirestore(object: FirestoreModel) {
        let collectionPath = object.collectionPath
        let reference = object.documentID != nil ? database.collection(collectionPath).document(object.documentID!) : database.collection(collectionPath).document()
        
        reference.setData(object.dictionary)
    }
    
    func setData(to collectionPath: String, documentID: String?, documentData: [String: Any]) {
        let collection = database.collection(collectionPath)
        let reference = documentID != nil ? collection.document(documentID!) : collection.document()
        reference.setData(documentData, merge: true)
    }
    
}
