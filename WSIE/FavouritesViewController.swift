//
//  FavouritesViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    var recipeList: [Recipe] = []
    var currentRecipe: Int = 0
    var recipeListIndexes: [Int] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear...")
        fetchRecipeDataAndUpdateTableView(db: db)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeDetailViewController {
            destinationViewController.currentRecipe = recipeList[currentRecipe]
            destinationViewController.recipes = recipes
            destinationViewController.currentRecipeIndex = recipeListIndexes[currentRecipe] // position of the recipe in the complete dataset
        }
    }
    
    func fetchRecipeDataAndUpdateTableView(db: Firestore) {
        recipes = [] // clear recipes
        db.collection("recipes").getDocuments() { (querySnapshot, err) -> Void in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Fetched documents successfully")
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    //print(document.data()["title"] as! String)
                    let recipe: Recipe = Recipe(title: document.data()["title"] as! String, shortDescription: document.data()["shortDescription"] as! String, cookingTime: document.data()["cookingTime"] as! Int, isFavourite: document.data()["isFavourite"] as! Bool, steps: document.data()["steps"] as! String, materials: document.data()["materials"] as! String, markDownCode: document.data()["md-code"] as! String, image: UIImage(named: "Gray")!)
                    self.recipes.append(recipe)
                    self.prepareDataset()
                    self.tableView.reloadData() // reload data when fetching completed
                }
                
            }
        }
    }
    
    func prepareDataset() {
        recipeList = []
        if recipes.count != 0 {
            for i in 0...recipes.count - 1 {
                if recipes[i].isFavourite == true {
                    recipeList.append(recipes[i])
                    recipeListIndexes.append(i)
                } else {
                    continue
                }
            }
        }
    }
}

extension FavouritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRecipe = indexPath.row
        performSegue(withIdentifier: "showRecipeDetailViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // recipe[recipeListIndexes[indexPath.row]].recipeIsFavourite = false // set recipeIsFavourite to false
            recipeList.remove(at: indexPath.row) // delete recipe from Recipe favourites list
            appDelegate.saveContext()
            tableView.reloadData()
        }
    }
    
}

extension FavouritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let currentRecipe = recipeList[indexPath.row]
        /*if let imageData = currentRecipe.value(forKeyPath: "recipeImageBinaryData") as? Data {
            if let recipeImage = UIImage(data: imageData){
                cell.recipeImageView?.image = recipeImage
            } else {
                cell.recipeImageView?.image = UIImage(named: "Gray") // change to no photo image later...
            }
        }*/
        
        cell.titleLabel.text = currentRecipe.title
        cell.shortDescriptionLabel.text = currentRecipe.shortDescription
        return cell
    }
    
    
}
