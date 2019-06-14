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

class OurRecommendationViewController: UIViewController {

    @IBOutlet weak var markdownView: MarkdownView!
    
    var recipe: [Recipe] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get the data from the database
        /*recipe = fetchData()
        if recipe.count != 0 {
            index = Int.random(in: 0 ..< recipe.count)
            let currentRecipe: Recipe = recipe[index]
            
            // markdownView.load(markdown: currentRecipe.recipeMarkdownCode)
        } else {
            // show alert...
            let alertController = UIAlertController(title: "Sorry!", message: "There are no recipes created. Please create some recipes that we can give you a recommendation", preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAlert)
            present(alertController, animated: true, completion: nil)
        } */
        
        
        
    }
    
    @IBAction func previousButtonHandler(_ sender: UIButton) {
        print("on back button pressed")
        if !(index <= 0) {
            index -= 1
        }
        /*
        let currentRecipe: Recipe = recipe[index]
        
        markdownView.load(markdown: currentRecipe.recipeMarkdownCode) */
    }
    
    @IBAction func nextButtonHandler(_ sender: UIButton) {
        print("on next button pressed")
        
        if !(index == recipe.count - 1) {
            index += 1
        } else {
            print("End of array!")
        }
        
        let currentRecipe: Recipe = recipe[index]
        /*
        markdownView.load(markdown: currentRecipe.recipeMarkdownCode) */
    }
    /*
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
    }*/

}
