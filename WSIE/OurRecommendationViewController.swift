//
//  OurRecommendationViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 09.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import MarkdownView
import CoreData
import Firebase

class OurRecommendationViewController: UIViewController {

    @IBOutlet weak var markdownView: MarkdownView!
    
    var recipes: [Recipe] = []
    var index: Int = 0
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        // print(Auth.auth().currentUser?.uid)
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        // markdownView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchRecipeDataAndLoadToMarkDownView(db: db)
        markdownView.translatesAutoresizingMaskIntoConstraints = true
        
        
        
    }
    
    @IBAction func previousButtonHandler(_ sender: UIButton) {
        print("on back button pressed")
        if !(index <= 0) {
            index -= 1
        }
        
        let currentRecipe: Recipe = recipes[index]
        
        markdownView.load(markdown: currentRecipe.markDownCode)
    }
    
    @IBAction func nextButtonHandler(_ sender: UIButton) {
        print("on next button pressed")
        
        if !(index == recipes.count - 1) {
            index += 1
        } else {
            print("End of array!")
        }
        
        let currentRecipe: Recipe = recipes[index]
        
        markdownView.load(markdown: currentRecipe.markDownCode)
    }
    
    func showRandomRecipe(recipe: [Recipe]) {
        print(recipes) // should print out something
        if recipe.count != 0 {
            index = Int.random(in: 0 ..< recipe.count)
            let currentRecipe: Recipe = recipe[index]
            
            markdownView.load(markdown: currentRecipe.markDownCode)
        } else {
            // show alert...
            let alertController = UIAlertController(title: "Sorry!", message: "There are no recipes created. Please create some recipes that we can give you a recommendation", preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAlert)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func fetchRecipeDataAndLoadToMarkDownView(db: Firestore) {
        recipes = [] // clear recipes
        db.collection("recipes\(Auth.auth().currentUser!.uid)").getDocuments() { (querySnapshot, err) -> Void in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Fetched documents successfully")
                for document in querySnapshot!.documents {
                    let personAmount: Int
                    if document.data()["forPerson"] == nil {
                        personAmount = 4 // fall back value for old recipes
                    } else {
                        personAmount = document.data()["forPerson"] as! Int
                    }
                    
                    let recipe: Recipe = Recipe(title: document.data()["title"] as! String, shortDescription: document.data()["shortDescription"] as! String, cookingTime: document.data()["cookingTime"] as! Int, isFavourite: document.data()["isFavourite"] as! Bool, steps: document.data()["steps"] as! String, materials: document.data()["materials"] as! String, markDownCode: document.data()["md-code"] as! String, image: UIImage(named: "Gray")!, personAmount: personAmount)
                    self.recipes.append(recipe)
                    self.showRandomRecipe(recipe: self.recipes)// reload data when fetching completed
                }
                
            }
        }
    }
}
