//
//  SearchableProtocol.swift
//  Coffee
//
//  Created by Khanh T Pham on 8/16/18.
//  Copyright © 2018 Khanh T. Pham. All rights reserved.
//

import Foundation

protocol Searchable {
//    var displayName: String {get}
    func contains(keyword: String) -> Bool
}

extension String: Searchable {
    var displayName: String {
        return self
    }
    func contains(keyword: String) -> Bool {
        return self.lowercased().contains(keyword.lowercased())
    }
    
}

protocol Presentable {
    var displayName: String {get}
}
