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
    var storage: Storage!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        storage = Storage.storage()
        storageRef = storage.reference()
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
        if Auth.auth().currentUser?.uid != nil {
            db.collection("recipes\(Auth.auth().currentUser!.uid)").getDocuments() { (querySnapshot, err) -> Void in
                if let err = err {
                    print("Error getting documents: \(err)")
                    let alert = UIAlertController(title: "Not logged in", message: "It seems that you are not logged in, please login to get your recipes!", preferredStyle: .alert)
                    let loginAction = UIAlertAction(title: "Log in", style: .default) { (nil) in
                        let loginViewController = LoginViewController()
                        self.present(loginViewController, animated: true) // show login view controller that user can login
                    }
                    alert.addAction(loginAction)
                    self.present(alert, animated: true)
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
                        self.prepareDataset()
                        self.tableView.reloadData() // reload data when fetching completed
                    }
                    
                }
            }
        } else {
            // show information that user is not logged in anymore
            let alert = UIAlertController(title: "Not logged in", message: "It seems that you are not logged in", preferredStyle: .alert)
            let loginAction = UIAlertAction(title: "Log in", style: .default) { (nil) in
                let loginViewController = LoginViewController()
                self.present(loginViewController, animated: true) // show login view controller that user can login
            }
            alert.addAction(loginAction)
            self.present(alert, animated: true)
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
            db.collection("recipes").document(recipeList[indexPath.row].title).updateData(["isFavourite": false]) { (err) in
                if let err = err {
                    print("Error updating dataset \(err)")
                } else {
                    print("Document updated successfully")
                }
            }
            recipeList.remove(at: indexPath.row)
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
        let currentRecipe = recipeList[indexPath.row] // get the recipe for the row
        
        let imageRef = storageRef.child("recipes\(Auth.auth().currentUser!.uid)/\(currentRecipe.title)/titleImage.jpg")
        
        imageRef.getData(maxSize: 20 * 1024 * 1024) { (data, err) in
            if let err = err {
                print("An error occured \(err)")
                cell.titleLabel.text = currentRecipe.title // get the recipe title
                cell.shortDescriptionLabel.text = currentRecipe.shortDescription // get the recipe short description
                cell.recipeImageView.image = UIImage(named: "NoPhoto")
            } else {
                cell.titleLabel.text = currentRecipe.title // get the recipe title
                cell.shortDescriptionLabel.text = currentRecipe.shortDescription // get the recipe short description
                cell.recipeImageView.image = UIImage(data: data!)
            }
        }
        
        
        
        return cell    }
    
    
}
