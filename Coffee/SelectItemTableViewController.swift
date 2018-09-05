//
//  SelectItemTableViewController.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/16/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import UIKit

class SelectItemTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var didSelect: ((_  item: Searchable) -> Void)?
    var didDeselect: ((_  item: Searchable) -> Void)?
    var sourceItems: [Searchable]!
    var filteredItems: [Searchable]!
    var allowMultipleSelection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = self.allowMultipleSelection
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        self.filteredItems = sourceItems
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
	
}

extension SelectItemTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)
        let item = filteredItems[indexPath.row] as! Presentable
        cell.textLabel?.text = item.displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    
        didSelect?(filteredItems[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        didDeselect?(filteredItems[indexPath.row])
    }
}

extension SelectItemTableViewController: UISearchResultsUpdating {
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredItems = searchBarIsEmpty() ? sourceItems : sourceItems.filter({ (item) -> Bool in
            return item.contains(keyword: searchText)
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
