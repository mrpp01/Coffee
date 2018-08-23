//
//  TabBarViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/13/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    
    var user: User!
    
    var bagsQuery: Query? {
        didSet {
            if let bagsListener = bagsListener {
                bagsListener.remove()
                observeBagsQuery()
            }
        }
    }
    var bagsListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.getUser()
        self.bagsQuery = baseBagsQuerry()
        user.database.collection(User.CollectionKeys.origins).getDocuments() { [unowned self](querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                print("Cannot fetch origins. Error: \(error!)")
                return
            }
            
            let origins = querySnapshot.documents.map {
                (document) -> Origin in
                return Origin(from: document)!
            }
            self.user.origins = origins
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeBagsQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBagsObserving()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TabBarViewController {
    func baseBagsQuerry() -> Query {
        print("Base querry")
        return Firestore.firestore().collection(User.CollectionKeys.bags)
    }
    
    func observeBagsQuery() {
        print("observeBagsQuery")
        guard let bagsQuery = bagsQuery else { return }
        stopBagsObserving()
        
        bagsListener = bagsQuery.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("error fetching snapshot results: \(error!)")
                return
            }
            
            let bags = snapshot.documents.map { (snapshotDocument) -> Bag in
                return Bag.createBag(from: snapshotDocument)!
            }
            self.user.bags = bags
            print("bag update")
        }
    }
    
    func stopBagsObserving() {
        bagsListener?.remove()
    }
    
}
