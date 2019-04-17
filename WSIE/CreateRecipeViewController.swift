//
//  CreateRecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData

class CreateRecipeViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var shortDescriptionTextView: UITextView!
    @IBOutlet weak var imageLinkTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescriptionTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonHandler(_ sender: Any) {
        print("OnSaveButtonPressed")
        guard let title = titleTextField.text else {
            return
        }
        guard let shortDescription = shortDescriptionTextView.text else {
            return
        }
        guard let imageLink = imageLinkTextView.text else {
            return
        }
        saveRecipe(title: title, shortDescription: shortDescription, imageLink: imageLink)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func saveRecipe(title: String, shortDescription: String, imageLink: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
        
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recipe.setValue(title, forKeyPath: "recipeTitle")
        recipe.setValue(shortDescription, forKeyPath: "recipeShortDescription")
        recipe.setValue(imageLink, forKey: "recipeImageLink")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save recipe. \(error), \(error.userInfo)")
        }
        print("Saved item..")
    }
    
    func showSaveAlert() {
    	let alertController = UIAlertController(title: "Unsaved changes", message: "Do you really want to exit?", preferredStyle = .alert)
    	let cancelALert = UIAlert(title: "Cancel", style: .cancel, handler: nil)
    	let saveAlert = UIAlert(title: "Save", style: .default, handler: nil)
    	alertController.addAction(cancelAlert)
    	alertController.addAction(saveAlert)
    	present(alertController)
    }
    
}

extension CreateRecipeViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
