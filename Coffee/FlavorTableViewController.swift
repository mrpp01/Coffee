//
//  FlavorTableViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/20/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit

class FlavorTableViewController: SelectItemTableViewController {
    
    private var sections = Array(flavor.keys)
    
    private var filteredDictionary: [String: [Flavor]] = [String: [Flavor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFilteredDictionary()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredDictionary.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(filteredDictionary.keys)[section]
       
        return flavor[key]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)
        cell.textLabel?.text = flavor[sections[indexPath.section]]![indexPath.row]
        
        return cell
    }
    
    override func filterContentForSearchText(_ searchText: String, scope: String) {
        super.filterContentForSearchText(searchText, scope: scope)
    }
    
    func updateFilteredDictionary() {
        filteredDictionary = [String: [Flavor]]()
        
        for item in filteredItems {
            if let flavor = item as? Flavor {
                if filteredDictionary[flavor.section] != nil { filteredDictionary[flavor.section] = [Flavor]() }
                else { filteredDictionary[flavor.section]?.append(flavor) }
            }
        }
    }
}
