//
//  Datatypes.swift
//  WSIE
//
//  Created by Pascal Boehler on 09.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {
    var title: String
    var shortDescription: String
    var cookingTime: Int
    var isFavourite: Bool
    var steps: String
    var materials: String
    var markDownCode: String
    var image: UIImage
}

struct ShoppingList {
    // var amount: Int
    var bought: Bool
    var name: String
}
