//
//  ShoppingListItem.swift
//  
//
//  Created by Pascal Boehler on 03.01.20.
//

import Foundation

struct ShoppingListItem: Hashable, Codable, Identifiable {
    var id: Int?
    var itemTitle: String
    var itemAmount: Int
    var itemUnit: String
    var isCompleted: Bool = false
    var uid: String
}
