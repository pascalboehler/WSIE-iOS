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
    @Published var isLoggedIn: Bool = true
    @Published var recipes = recipeData
    
}
