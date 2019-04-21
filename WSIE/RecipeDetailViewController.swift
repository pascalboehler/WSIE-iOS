//
//  RecipeDetailViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import MarkdownView

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var markdownView: MarkdownView!
    var currentRecipe: Recipe?
    var currentRecipeIndex: Int?
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // markdownView.load(markdown: "# Hello World!")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        markdownView.load(markdown: currentRecipe!.recipeMarkdownCode)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditRecipeViewController {
            destinationViewController.currentRecipe = currentRecipe
            destinationViewController.recipes = recipes
            destinationViewController.currentRecipeIndex = currentRecipeIndex
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

