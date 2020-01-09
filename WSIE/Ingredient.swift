//
//  Ingredient.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation

struct Ingredient: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var amount: Int
    var unit: String
}
