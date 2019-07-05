//
//  RecipeDetailViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import MarkdownView
import Firebase

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var favouriteBarButton: UIBarButtonItem!
    
    var currentRecipe: Recipe?
    var currentRecipeIndex: Int?
    var recipes: [Recipe] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // markdownView.load(markdown: "# Hello World!")
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        markdownView.load(markdown: currentRecipe!.markDownCode)
        markdownView.translatesAutoresizingMaskIntoConstraints = true
        if currentRecipe?.isFavourite == false {
            favouriteBarButton.tintColor = UIColor.lightGray
        } else {
            favouriteBarButton.tintColor = UIColor.blue
        }
    }
    
    func updateDataset() {
        db.collection("recipes").document(currentRecipe!.title).updateData(["isFavourite": currentRecipe!.isFavourite]) { (err) in
            if let err = err {
                print("Error updating dataset \(err)")
            } else {
                print("Document updated successfully")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditRecipeViewController {
            destinationViewController.currentRecipe = currentRecipe
            destinationViewController.recipes = recipes
            destinationViewController.currentRecipeIndex = currentRecipeIndex
        }
    }
    
    @IBAction func favouriteBarButtonHandler(_ sender: UIBarButtonItem) {
        if currentRecipe?.isFavourite == false {
            currentRecipe?.isFavourite = true
            favouriteBarButton.tintColor = UIColor.blue
            updateDataset()
        } else {
            currentRecipe?.isFavourite = false
            favouriteBarButton.tintColor = UIColor.lightGray
            updateDataset()
        }
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        // quits the ViewController
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowEditRecipeViewController", sender: nil)
    }
}

