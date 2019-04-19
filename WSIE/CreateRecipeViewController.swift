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
    
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var shortDescriptionLabel: UILabel!
    var shortDescriptionTextView: UITextView!
    var cookingTimeLabel: UILabel!
    var cookingTimeDatePicker: UIDatePicker!
    var pictureLabel: UILabel!
    var picturePicker: UIButton!
    var materialsLabel: UILabel!
    //var materialsTableView: UITableView!
    var materialsTextView: UITextView!
    var stepsLabel: UILabel!
    //var stepsTableView: UITableView!
    var stepsTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width - 16, height: 1000)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 50))
        titleLabel.text = "Recipe title: "
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 30))
        titleTextField.placeholder = "Insert a title for the recipe"
        self.scrollView.addSubview(titleTextField)
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        pictureLabel.text = "Recipe image: "
        pictureLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        pictureLabel.textAlignment = .center
        scrollView.addSubview(pictureLabel)
        
        picturePicker = UIButton(frame: CGRect(x: 0, y: pictureLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: CGFloat(self.scrollView.bounds.width*(2.0/3.0))))
        picturePicker.backgroundColor = UIColor.lightGray
        picturePicker.addTarget(self, action: #selector(picturePickerButtonHandler(sender:)), for: .touchUpInside)
        scrollView.addSubview(picturePicker)
        
        materialsLabel = UILabel(frame: CGRect(x: 0, y: Int(picturePicker.frame.maxY + 8), width: Int(self.scrollView.bounds.width), height: 50))
        materialsLabel.text = "Materials: "
        materialsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        materialsLabel.textAlignment = .center
        scrollView.addSubview(materialsLabel)
        
        materialsTextView = UITextView(frame: CGRect(x: 0, y: materialsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        materialsTextView.isEditable = true
        materialsTextView.autocapitalizationType = .sentences
        materialsTextView.autocorrectionType = .default
        materialsTextView.delegate = self
        scrollView.addSubview(materialsTextView)
        
        stepsLabel = UILabel(frame: CGRect(x: 0, y: materialsTextView.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        stepsLabel.text = "Steps: "
        stepsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        stepsLabel.textAlignment = .center
        scrollView.addSubview(stepsLabel)
        
        stepsTextView = UITextView(frame: CGRect(x: 0, y: stepsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        stepsTextView.isEditable = true
        stepsTextView.autocapitalizationType = .sentences
        stepsTextView.autocorrectionType = .default
        stepsTextView.delegate = self
        scrollView.addSubview(stepsTextView)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func picturePickerButtonHandler(sender: UIButton) {
        print("picturePicker pressed...")
    }
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        showSaveAlert()
        // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonHandler(_ sender: Any) {
        print("OnSaveButtonPressed")
        
        guard let title = titleTextField.text else {
            return
        }
        
        guard let shortDescription = shortDescriptionTextView.text else {
            return
        }
        
        // guard let cookingTime = cookingTimePicker.v
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveRecipe(title: String, shortDescription: String, cookingTime: Int, imageLink: String, materials: String, steps: String, isFavourite: Bool = false, recipeMarkDown: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
        
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recipe.setValue(title, forKey: "recipeTitle")
        recipe.setValue(shortDescription, forKey: "recipeShortDescription")
        recipe.setValue(imageLink, forKey: "recipeImageLink")
        recipe.setValue(materials, forKey: "recipeMaterials")
        recipe.setValue(steps, forKey: "recipeSteps")
        recipe.setValue(isFavourite, forKey: "recipeIsFavourite")
        recipe.setValue(recipeMarkDown, forKey: "recipeMarkdown")
        
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
            /*
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
 */
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

