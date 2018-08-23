//
//  SearchableProtocol.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/16/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation

protocol Searchable {
    var displayName: String {get}
    func contains(keyword: String) -> Bool
}

extension Bag: Searchable {
    
    var displayName: String { return brandName }
    
    func contains(keyword: String) -> Bool {
        return self.brandName.lowercased().contains(keyword.lowercased())
    }
}

extension Origin: Searchable {
    var displayName: String { return country }
    
    func contains(keyword: String) -> Bool {
        return self.country.lowercased().contains(keyword.lowercased())
    }
}

extension String: Searchable {
    var displayName: String {
        return self
    }
    func contains(keyword: String) -> Bool {
        return self.lowercased().contains(keyword.lowercased())
    }
    
}

extension Flavor: Searchable {
    var displayName: String {
        return section + "- " + subSection
    }
    
    func contains(keyword: String) -> Bool {
        return self.section.lowercased().contains(keyword: keyword.lowercased()) || self.subSection.lowercased().contains(keyword: keyword.lowercased())
    }
}


