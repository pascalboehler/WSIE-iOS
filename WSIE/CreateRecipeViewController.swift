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
    var materialsTextView: UITextView!
    var stepsLabel: UILabel!
    var stepsTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imagePickerController: UIImagePickerController!
    
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width - 16, height: 1500)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 50))
        titleLabel.text = "Recipe title: "
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 30))
        titleTextField.placeholder = "Insert a title for the recipe"
        scrollView.addSubview(titleTextField)
        
        cookingTimeLabel = UILabel(frame: CGRect(x: 0, y: titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        cookingTimeLabel.text = "Cooking time: "
        cookingTimeLabel.textAlignment = .left
        cookingTimeLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(cookingTimeLabel)
        
        cookingTimeDatePicker = UIDatePicker(frame: CGRect(x: 0, y: cookingTimeLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        cookingTimeDatePicker.datePickerMode = .countDownTimer
        cookingTimeDatePicker.minuteInterval = 1
        scrollView.addSubview(cookingTimeDatePicker)
        
        shortDescriptionLabel = UILabel(frame: CGRect(x: 0, y: cookingTimeDatePicker.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        shortDescriptionLabel.text = "Recipe short description: "
        shortDescriptionLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        shortDescriptionLabel.textAlignment = .left
        scrollView.addSubview(shortDescriptionLabel)
        
        shortDescriptionTextView = UITextView(frame: CGRect(x: 0, y: shortDescriptionLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        shortDescriptionTextView.isEditable = true
        shortDescriptionTextView.autocapitalizationType = .sentences
        shortDescriptionTextView.autocorrectionType = .default
        scrollView.addSubview(shortDescriptionTextView)
        
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: shortDescriptionTextView.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        pictureLabel.text = "Recipe image: "
        pictureLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        pictureLabel.textAlignment = .left
        scrollView.addSubview(pictureLabel)
        
        picturePicker = UIButton(frame: CGRect(x: 0, y: pictureLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: CGFloat(self.scrollView.bounds.width*(2.0/3.0))))
        picturePicker.backgroundColor = UIColor.lightGray
        picturePicker.addTarget(self, action: #selector(picturePickerButtonHandler(sender:)), for: .touchUpInside)
        scrollView.addSubview(picturePicker)
        
        materialsLabel = UILabel(frame: CGRect(x: 0, y: Int(picturePicker.frame.maxY + 8), width: Int(self.scrollView.bounds.width), height: 50))
        materialsLabel.text = "Materials: "
        materialsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        materialsLabel.textAlignment = .left
        scrollView.addSubview(materialsLabel)
        
        materialsTextView = UITextView(frame: CGRect(x: 0, y: materialsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        materialsTextView.isEditable = true
        materialsTextView.autocapitalizationType = .sentences
        materialsTextView.autocorrectionType = .default
        scrollView.addSubview(materialsTextView)
        
        stepsLabel = UILabel(frame: CGRect(x: 0, y: materialsTextView.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        stepsLabel.text = "Steps: "
        stepsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        stepsLabel.textAlignment = .left
        scrollView.addSubview(stepsLabel)
        
        stepsTextView = UITextView(frame: CGRect(x: 0, y: stepsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        stepsTextView.isEditable = true
        stepsTextView.autocapitalizationType = .sentences
        stepsTextView.autocorrectionType = .default
        scrollView.addSubview(stepsTextView)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func picturePickerButtonHandler(sender: UIButton) {
        print("picturePicker pressed...")
        // get the image
        // initalize the imagePickerController
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imageSourceAlert = UIAlertController(title: "Input source", message: "Choose your input source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Photo library", style: .default) { _ in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        imageSourceAlert.addAction(cameraAction)
        imageSourceAlert.addAction(libraryAction)
        imageSourceAlert.addAction(cancelAction)
        
        present(imageSourceAlert, animated: true)
        
    }
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        showSaveAlert()
    }
    
    @IBAction func saveButtonHandler(_ sender: Any) {
        print("OnSaveButtonPressed")
        
        let image: UIImage
        
        guard let title = titleTextField.text else {
            return
        }
        
        guard let shortDescription = shortDescriptionTextView.text else {
            return
        }
        
        let cookingTime = Int(cookingTimeDatePicker.countDownDuration) / 60
        
        
        if let imageTemp = picturePicker.currentBackgroundImage{
            image = imageTemp
        } else {
            print("Could not find background image...")
            image = UIImage(named: "Gray")!
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Cast to imageData went wrong")
            return
        }
        
        guard let materials = materialsTextView.text else {
            return
        }
        
        guard let steps = stepsTextView.text else {
            return
        }
        
        let recipeMarkDown = markdownFormatter(recipeTitle: title, recipeShortDescription: shortDescription, recipeCookingTime: cookingTime, recipeMaterialsList: materials, recipeStepsList: steps, forPerson: 1)
        
        print(recipeMarkDown)
        
        saveRecipe(title: title, shortDescription: shortDescription, cookingTime: cookingTime, image: NSData(data: imageData), materials: materials, steps: steps, recipeMarkDown: recipeMarkDown)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveRecipe(title: String, shortDescription: String, cookingTime: Int, image: NSData, materials: String, steps: String, isFavourite: Bool = false, recipeMarkDown: String) {
        
        print("Recipe saved")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
        
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recipe.setValue(title, forKey: "recipeTitle")
        recipe.setValue(shortDescription, forKey: "recipeShortDescription")
        recipe.setValue(image, forKey: "recipeImageBinaryData")
        recipe.setValue(materials, forKey: "recipeMaterials")
        recipe.setValue(steps, forKey: "recipeSteps")
        recipe.setValue(isFavourite, forKey: "recipeIsFavourite")
        recipe.setValue(recipeMarkDown, forKey: "recipeMarkdownCode")
        
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
            
            guard let title = self.titleTextField.text else {
                self.missingElementAlert(forElement: "title")
                return
            }
            
            guard let shortDescription = self.shortDescriptionTextView.text else {
                self.missingElementAlert(forElement: "shortDescription")
                return
            }
            
            let cookingTime = Int(self.cookingTimeDatePicker.countDownDuration)
            
            guard let imageLink = self.picturePicker.currentImage else {
                return
            }
            
            guard let imageData = imageLink.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            guard let materials = self.materialsTextView.text else {
                self.missingElementAlert(forElement: "materials")
                return
            }
            
            guard let steps = self.stepsTextView.text else {
                self.missingElementAlert(forElement: "steps")
                return
            }
            
            self.saveRecipe(title: title, shortDescription: shortDescription, cookingTime: cookingTime, image: NSData(data: imageData), materials: materials, steps: steps, recipeMarkDown: "")
            
            self.dismiss(animated: true, completion: nil)
        })
    	alertController.addAction(cancelAlert)
    	alertController.addAction(saveAlert)
    	present(alertController, animated: true)
    }
    
    func missingElementAlert(forElement cases: String) {
        let alert = UIAlertController(title: "Missing Element", message: "There is something wrong!", preferredStyle: .alert)
        
        
        switch cases {
        case "title":
            alert.message = "Please insert a title for the recipe!"
            break
        case "shortDescription":
            alert.message = "Please insert a short description for the recipe!"
            break
        case "materials":
            alert.message = "Please insert materials for the recipe!" // change later to Image...
            break
        case "steps":
            alert.message = "Please insert steps for the recipe!"
            break
        default:
            alert.message = "Please insert the missing attributes for the recipe!"
        }
        
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}



extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picturePicker.setBackgroundImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
}

