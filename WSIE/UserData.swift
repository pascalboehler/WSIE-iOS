//
//  UserData.swift
//  WSIE
//
//  Created by Pascal Boehler on 25.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import SwiftUI
import Combine

public class UserData: ObservableObject {
    @Published var showFavouritesOnly: Bool = false
    //@Published var recipes = recipeData
    @Published var shoppingList = shoppingListTestData
    @Published var showCompleted: Bool = false
}
