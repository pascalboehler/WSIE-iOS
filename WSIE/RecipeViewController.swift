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
    var storage: Storage!
    var storageRef: StorageReference!
    
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
    @objc var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //recipe = fetchData()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        // Firebase
        // db
        // setup database
        let settings = FirestoreSettings()
        // print(Auth.auth().currentUser?.uid)
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        tableView.refreshControl = refreshControl // add refreshControl to tableView
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        // storage
        storage = Storage.storage()
        storageRef = storage.reference()
    }
    
    @objc func refreshTableView() {
        fetchRecipeDataAndUpdateTableView(db: db)
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        // db
        db.collection("recipes\(Auth.auth().currentUser!.uid)").getDocuments() { (querySnapshot, err) -> Void in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Fetched documents successfully")
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    //print(document.data()["title"] as! String)
                    let recipe: Recipe = Recipe(title: document.data()["title"] as! String, shortDescription: document.data()["shortDescription"] as! String, cookingTime: document.data()["cookingTime"] as! Int, isFavourite: document.data()["isFavourite"] as! Bool, steps: document.data()["steps"] as! String, materials: document.data()["materials"] as! String, markDownCode: document.data()["md-code"] as! String, image: UIImage(named: "Gray")!)
                    self.recipes.append(recipe)
                    //self.tableView.reloadData() // reload data when fetching completed
                }
                /*
                let recipeFolderRef = self.storageRef.child("recipe")
                if self.recipes.count == 0 {
                    self.tableView.reloadData()
                } else {
                    print(self.recipes.count)
                    for i in 0...self.recipes.count - 1{
                        let imageFolderRef = recipeFolderRef.child(self.recipes[i].title)
                        let imageRef = imageFolderRef.child("titleImage.jpg") // URL to image in cloud storage
                        // Download the image
                        imageRef.getData(maxSize: 20 * 1024 * 1024) { (data, err) in // 20 MB => filesize 5.9 MB
                            if let err = err {
                                print("Something went wrong with \(err)")
                                self.recipes[i].image = UIImage(named: "NoPhoto")!
                                print("Set image to NoPhoto")
                            } else {
                                self.recipes[i].image = UIImage(data: data!)!
                            }
                        }
                    }
                    print("Reload data...")
                    self.tableView.reloadData()
                    print("Reloaded TableViewData")
                }*/
                self.tableView.reloadData()
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
        return true
    }
    
    
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
 
    
    func deleteRecipe(forRowAt indexPath: IndexPath) {
        db.collection("recipes\(Auth.auth().currentUser!.uid)").document(recipes[indexPath.row].title).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                let alert = UIAlertController(title: "Error deleting recipe!", message: "An error occured while deleting the recipe, please try again later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Document successfully removed!")
                let imageRef = self.storageRef.child("recipes\(Auth.auth().currentUser!.uid)/\(self.recipes[indexPath.row].title)/titleImage.jpg")
                imageRef.delete() { err in
                    if let err = err {
                        print("Something went wrong \(err)")
                    } else {
                        print("Deleted image")
                    }
                }
                self.fetchRecipeDataAndUpdateTableView(db: self.db) // reload data...
            }
        }
    }
    
}

extension RecipeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let currentRecipe = recipes[indexPath.row] // get the recipe for the row
        
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
                self.recipes[indexPath.row].image = UIImage(data: data!)! // set the image in recipe array
            }
        }
        
        
        
        return cell
    }
}
