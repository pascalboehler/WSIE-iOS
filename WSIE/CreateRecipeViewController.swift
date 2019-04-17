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
    
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescriptionTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditRecipeViewController {
            
        }
    }
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        showSaveAlert()
        // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonHandler(_ sender: Any) {
        print("OnSaveButtonPressed")
        guard let title = self.titleTextField.text else {
            self.missingElementAlert(missingElement: "title")
            return
        }
        guard let shortDescription = self.shortDescriptionTextView.text else {
            self.missingElementAlert(missingElement: "shortDecription")
            return
        }
        guard let imageLink = self.imageLinkTextView.text else {
            self.missingElementAlert(missingElement: "imageLink")
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
    	let alertController = UIAlertController(title: "Unsaved changes", message: "There are some unsaved changes. Do you really want to exit and discard the changes?", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            self.dismiss(animated: true, completion: nil)
        })
    	let saveAlert = UIAlertAction(title: "Save", style: .default, handler: {
            _ in
            guard let titleString = self.titleTextField.text else {
                self.missingElementAlert(missingElement: "title")
                return
            }
            guard let shortDescriptionString = self.shortDescriptionTextView.text else {
                self.missingElementAlert(missingElement: "shortDecription")
                return
            }
            guard let imageLink = self.imageLinkTextView.text else {
                self.missingElementAlert(missingElement: "imageLink")
                return
            }
            self.saveRecipe(title: titleString, shortDescription: shortDescriptionString, imageLink: imageLink)
            self.dismiss(animated: true, completion: nil)
        })
    	alertController.addAction(cancelAlert)
    	alertController.addAction(saveAlert)
    	present(alertController, animated: true)
    }
    
    func missingElementAlert(missingElement element: String) {
        let alert = UIAlertController(title: "Missing Element", message: "", preferredStyle: .alert)
        
        switch element {
        case "title":
            alert.message = "Please insert a title for the recipe!"
            break
        case "shortDescription":
            alert.message = "Please insert a short description for the recipe!"
            break
        case "imageLink":
            alert.message = "Please insert a image link for the recipe!" // change later to Image...
        default:
            alert.message = "Please insert the missing attributes for the recipe!"
        }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
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
