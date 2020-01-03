//
//  Data.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import Alamofire

// With local file:
//var recipeData: [Recipe] = loadLocal("recipes.json")
// from server
var recipeData: [Recipe] = loadFromApi()

//fileprivate var db: Firestore!

func loadLocal<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func loadFromApi() -> [Recipe] {
    var recipes: [Recipe] = []
    //let urlString = "http://localhost:8080/recipe/UID/\(Auth.auth().currentUser!.uid)"
    
    let urlString = "http://localhost:8080/recipe" // receive all public elements => for testing
    guard let url = URL(string: urlString) else {
        return []
    }
    Alamofire.request(url, method: .get).validate().responseData { response in
        guard response.result.isSuccess else {
            print("ERROR WHILE FETCHING DATA")
            return
        }
        do {
            let decoder = JSONDecoder()
            try recipes =  decoder.decode([Recipe].self, from: response.result.value!)
        } catch {
            fatalError("Couldn't parse \(url) as \([Recipe].self):\n\(error)")
        }
    }
    print(recipes)
    return recipes
}

class NetworkManager : ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    
    init() {
        loadFromApi()
    }
    
    private func loadFromApi() {
        let urlString = "http://localhost:8080/recipe" // receive all public elements => for testing
        guard let url = URL(string: urlString) else {
            print("WRONG URL")
            return
        }
        Alamofire.request(url, method: .get).validate().responseData { response in
            guard response.result.isSuccess else {
                print("ERROR WHILE FETCHING DATA")
                return
            }
            do {
                let decoder = JSONDecoder()
                try self.recipes =  decoder.decode([Recipe].self, from: response.result.value!)
                self.isLoading = false
            } catch {
                fatalError("Couldn't parse \(url) as \([Recipe].self):\n\(error)")
            }
        }
    }
    
    func reloadData() {
        loadFromApi()
    }
}
