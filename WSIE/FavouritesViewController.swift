//
//  FavouritesViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recipe: [Recipe] = []
    var recipeList: [Recipe] = []
    var currentRecipe: Int = 0
    var recipeListIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear...")
        recipe = fetchData()
        // reload the tableView data when view appears
        recipeList = []
        prepareDataset()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeDetailViewController {
            destinationViewController.currentRecipe = recipeList[currentRecipe]
            destinationViewController.recipes = recipe
            destinationViewController.currentRecipeIndex = recipeListIndexes[currentRecipe] // position of the recipe in the complete dataset
        }
    }
    
    func fetchData() -> [Recipe]{
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
    }
    
    func prepareDataset() {
        if recipe.count != 0 {
            for i in 0...recipe.count - 1 {
                if recipe[i].recipeIsFavourite == true {
                    recipeList.append(recipe[i])
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
        if editingStyle = .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            recipe[recipeListIndexes[indexPath.row]].recipeIsFavourite = false // set recipeIsFavourite to false
            appDelegate.saveContext()
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
        if let imageData = currentRecipe.value(forKeyPath: "recipeImageBinaryData") as? Data {
            if let recipeImage = UIImage(data: imageData){
                cell.recipeImageView?.image = recipeImage
            } else {
                cell.recipeImageView?.image = UIImage(named: "Gray") // change to no photo image later...
            }
        }
        
        cell.titleLabel.text = currentRecipe.value(forKeyPath: "recipeTitle") as? String
        cell.shortDescriptionLabel.text = currentRecipe.value(forKeyPath: "recipeShortDescription") as? String
        
        return cell
    }
    
    
}
