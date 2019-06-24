//
//  RecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class RecipeViewController: UIViewController {

    var db: Firestore!
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Recipe dataset ONLY FOR TESTING !!!
    /*let recipe = [
        ["Title 1", "Title 2", "Tiltle 3", "Title 4", "Title 5"], // Titles
        ["velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor", "velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor", "velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor", "velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor", "velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor"], // Short Descriptions
        ["Clock", "Clock", "Clock", "Clock", "Clock"], // Images (links to images
    ] */
    //var recipe: [Recipe] = []
    var recipes: [Recipe] = [] // Array of dictionaries to store data
    var recipeIds: [String] = []
    var currentRecipe: Int = 0
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //recipe = fetchData()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        // setup database
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        tableView.refreshControl = refreshControl // add refreshControl to tableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear...")
        // recipe = fetchData()
        // reload the tableView data when view appears
        fetchRecipeDataAndUpdateTableView(db: db)
        //tableView.reloadData()
    }
    
    @IBAction func addRecipeButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowCreateRecipeViewController", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeDetailViewController {
            destinationViewController.currentRecipe = recipes[currentRecipe]
            destinationViewController.recipes = recipes
            destinationViewController.currentRecipeIndex = currentRecipe
        }
    }
    /*
    func fetchDatag() -> [Recipe]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        return []
    }*/
    
    /*func fetchData() -> [[String: Any]] {
        var data: [[String: Any]] = [[:]]
        var dataTemp: [String: Any] = [:]
        db.collection("recipe").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else{
                for document in querySnapshot!.documents {
                    data.append(document.data())
                    print(document.data())
                    print(document.documentID)
                    self.recipeIds.append(document.documentID)
                }
            }
            
        }
        print(data)
        print(recipeIds)
        return data
    }*/
    
    func fetchRecipeDataAndUpdateTableView(db: Firestore) {
        recipes = [] // clear recipes
        db.collection("recipe").getDocuments() { (querySnapshot, err) -> Void in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Fetched documents successfully")
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    //print(document.data()["title"] as! String)
                    let recipe: Recipe = Recipe(title: document.data()["title"] as! String, shortDescription: document.data()["shortDescription"] as! String, cookingTime: document.data()["cookingTime"] as! Int, isFavourite: document.data()["isFavourite"] as! Bool, steps: document.data()["steps"] as! String, materials: document.data()["materials"] as! String, markDownCode: document.data()["md-code"] as! String, image: UIImage(named: "Gray")!)
                    //print(recipe)
                    self.recipes.append(recipe)
                    //print(recipes)
                    print(self.recipes)
                    self.tableView.reloadData() // reload data when fetching completed
                }
                
            }
        }
    }
}

extension RecipeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRecipe = indexPath.row
        performSegue(withIdentifier: "ShowRecipeDetailViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete recipe", message: "Are you sure that you want to delete this recipe", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.deleteRecipe(forRowAt: indexPath)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
    }
 */
    /*
    func deleteRecipe(forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print("Deleted Recipe...")
        let deletedRecipe = recipe[indexPath.row]
        context.delete(deletedRecipe)
        recipe.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        appDelegate.saveContext()
    }
    */
}

extension RecipeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        /*
        let currentRecipe = recipe[indexPath.row]
        if let imageData = currentRecipe.value(forKeyPath: "recipeImageBinaryData") as? Data {
            if let recipeImage = UIImage(data: imageData){
                cell.recipeImageView?.image = recipeImage
            } else {
                cell.recipeImageView?.image = UIImage(named: "Gray") // change to no photo image later...
            }
        }
 
        cell.titleLabel.text = currentRecipe.value(forKeyPath: "recipeTitle") as? String
        cell.shortDescriptionLabel.text = currentRecipe.value(forKeyPath: "recipeShortDescription") as? String
        
        return cell */
        
        let currentRecipe = recipes[indexPath.row] // get the recipe for the row
        
        cell.titleLabel.text = currentRecipe.title as? String // get the recipe title
        cell.shortDescriptionLabel.text = currentRecipe.shortDescription as? String // get the recipe short description
        /*if let imageData = currentRecipe.image as? Data {
            if let recipeImage = UIImage(data: imageData){
                cell.recipeImageView?.image = recipeImage
            } else {
                cell.recipeImageView?.image = UIImage(named: "Gray") // change to no photo image later...
            }
        }*/
        let image = currentRecipe.image as! UIImage
        cell.recipeImageView.image = image
        
        return cell
    }
}
