//
//  Caching.swift
//  WSIE
//
//  Created by Pascal Boehler on 14.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import Foundation

class Caching {
    var docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // User document directory
    
    // MARK: - Recipe
    func writeRecipeDataToCache(recipes: [Recipe]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(recipes)
            guard var url = docDir else {
                print("Couldn't parse url")
                return
            }
            url.appendPathComponent("recipe.json")
            try data.write(to: url, options: .completeFileProtectionUntilFirstUserAuthentication)
        } catch {
            fatalError("Unable to load file from disk")
        }
    }
    
    func readRecipeDataFromCache() -> [Recipe] {
        let decoder = JSONDecoder()
        do {
            guard var url = docDir else {
                print("Could'nt parse url")
                return []
            }
            url.appendPathComponent("recipe.json")
            let data = try Data(contentsOf: url)
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            print("Unable to load data from disk!")
            return []
        }
    }
    
    // MARK: - Shopping List
    func writeShoppingListDataToCache(list: [ShoppingListItem]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(list)
            guard var url = docDir else {
                print("Couldn't parse url")
                return
            }
            url.appendPathComponent("shoppingList.json")
            try data.write(to: url, options: .completeFileProtectionUntilFirstUserAuthentication)
        } catch {
            fatalError("Unable to write data to disk!")
        }
    }

    func readShoppingListDataFromCache() -> [ShoppingListItem] {
        let decoder = JSONDecoder()
        do {
            guard var url = docDir else {
                print("Couldn't parse url")
                return []
            }
            url.appendPathComponent("shoppingList.json")
            let data = try Data(contentsOf: url)
            return try decoder.decode([ShoppingListItem].self, from: data)
        } catch {
            return []
        }
    }
}
