//
//  AddIngredient.swift
//  WSIE
//
//  Created by Pascal Boehler on 10.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import Foundation

struct AddIngredient: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var amount: String
    var unit: String
}

