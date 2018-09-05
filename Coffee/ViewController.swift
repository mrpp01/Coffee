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
    var activities: [Activity]!
    var database: Firestore! {
        didSet {
            let settings = database.settings
            settings.areTimestampsInSnapshotsEnabled = false
            database.settings = settings
        }
    }
    
    var activitiesQuery :Query? {
        didSet {
            if let activitiesListener = activitiesListener {
                activitiesListener.remove()
                observeActivitiesQuery()
            }
        }
    }
    var activitiesListener: ListenerRegistration?
    
    @IBAction func demoAction(_ sender: UIButton) {
    }
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.getUser()
        database = user.database
        bags = user.bags
        brews = user.brews
        activitiesQuery = baseActivitiesQuerry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        observeActivitiesQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopActivitiesObserving()
    }
}

//MARK: Notification
extension ViewController {
    @objc func handle(notification: Notification) {

    }
    
    func addObserver() {
//        let center = NotificationCenter.default
//        center.addObserver(self, selector: #selector(handle(notification:)), name: Notification.Name.BagDidChange, object: nil)
    }
}

//MARK: Firebase Observation
extension ViewController {
    func baseActivitiesQuerry() -> Query {
        return Firestore.firestore().collection(User.CollectionKeys.activities)
    }
    
    func observeActivitiesQuery() {
        guard let activitiesQuery = activitiesQuery else { return }
        stopActivitiesObserving()
        
        activitiesListener = activitiesQuery.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("error fetching snapshot results: \(error!)")
                return
            }
            
            let activities = snapshot.documents.map { (snapshotDocument) -> Activity in
                return Activity(from: snapshotDocument)!
            }
            self.activities = activities
            print("observeActivitiesQuery")
        }
    }
    
    func stopActivitiesObserving() {
        activitiesListener?.remove()
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
