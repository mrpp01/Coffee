//
//  ViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 7/17/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    
    var user: User!
    var bags: [Bag]!
    var brews: [Brew]!
    var database: Firestore! {
        didSet {
            let settings = database.settings
            settings.areTimestampsInSnapshotsEnabled = false
            database.settings = settings
        }
    }
    
    var bagQuery :Query? {
        didSet {
            if let bagListener = bagListener {
                bagListener.remove()
                observeBagQuery()
            }
        }
    }
    var bagListener: ListenerRegistration?
    
    var brewQuery :Query? {
        didSet {
            if let brewListener = brewListener {
                brewListener.remove()
                observeBrewQuery()
            }
        }
    }
    var brewListener: ListenerRegistration?
    
    @IBAction func demoAction(_ sender: UIButton) {
    }
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.getUser()
        database = user.database
        bags = user.bags
        brews = user.brews
        bagQuery = baseBagQuerry()
        brewQuery = baseBrewQuerry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        observeBagQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBagObserving()
    }
}

//MARK: Notification
extension ViewController {
    @objc func handle(notification: Notification) {
    }
    
    func addObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(handle(notification:)), name: Notification.Name.BagDidChange, object: nil)
    }
}

//MARK: Firebase Observation
extension ViewController {
    func baseBagQuerry() -> Query {
        return Firestore.firestore().collection(User.CollectionKeys.bags)
    }
    
    func observeBagQuery() {
        guard let bagQuery = bagQuery else { return }
        stopBagObserving()
        
        bagListener = bagQuery.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("error fetching snapshot results: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (snapshotDocument) -> Bag in
                return Bag.createBag(from: snapshotDocument)!
            }
            self.bags = models
        }
    }
    
    func stopBagObserving() {
        bagListener?.remove()
    }
    
    func baseBrewQuerry() -> Query {
        return Firestore.firestore().collection(User.CollectionKeys.brews)
    }
    
    func observeBrewQuery() {
        guard let brewQuery = brewQuery else { return }
        stopBagObserving()
        
        brewListener = brewQuery.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("error fetching snapshot results: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (snapshotDocument) -> Brew in
                return Brew(with: snapshotDocument)!
            }
            self.brews = models
        }
    }
    
    func stopBrewObserving() {
        brewListener?.remove()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
