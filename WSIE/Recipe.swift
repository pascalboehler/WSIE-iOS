//
//  Recipe.swift
//  WSIE
//
//  Created by Pascal Boehler on 25.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation
import SwiftUI

struct Recipe: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var timeNeeded: String
    var isFavourite: Bool
    var ingredients: [Ingredient]
    var steps: [Step]
    var shortDescription: String
    var uid: String
    var imageName: String = "NoPhoto"
    var personAmount: Int = 4
    var sharedWith: [String] // for future see kanban for information
    
    enum Category: String, CaseIterable, Codable, Hashable {
        case breakfast = "Breakfast"
        case dinner = "Dinner"
        case lunch = "Lunch"
        case dessert = "Dessert"
        case sweet = "Sweet"
        case savoury = "Savoury"
    }
}

/*
extension Recipe {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
*/
