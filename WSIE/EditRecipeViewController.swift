//
//  EditRecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 17.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class EditRecipeViewController: UIViewController {

    // UI Elements
    
    // Code defined
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var cookingTimeLabel: UILabel!
    var cookingTimeDatePicker: UIDatePicker!
    var shortDescriptionLabel: UILabel!
    var shortDescriptionTextView: UITextView!
    var pictureLabel: UILabel!
    var picturePicker: UIButton!
    var materialsLabel: UILabel!
    //var materialsTableView: UITableView!
    var materialsTextView: UITextView!
    var stepsLabel: UILabel!
    //var stepsTableView: UITableView!
    var stepsTextView: UITextView!
    
    var imagePickerController: UIImagePickerController!
    
    // IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    // variables
    var currentRecipe: Recipe?
    var recipes: [Recipe] = []
    var currentRecipeIndex: Int?
    
    var recipeTitle: String?
    var recipeShortDescription: String?
    var recipeMaterials: String?
    var recipeSteps: String?
    var recipeImage: UIImage?
    var recipeCookingTime: Int?
    var recipePreparationtime: Int?
    var recipeMarkdownCode: String?
    
    // Firebase
    var db: Firestore!
    
    // Storage
    var storage: Storage!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Add all the additional elements to the view
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
        self.scrollView.addSubview(titleTextField)
        
        cookingTimeLabel = UILabel(frame: CGRect(x: 0, y: titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        cookingTimeLabel.text = "Cooking time: "
        cookingTimeLabel.textAlignment = .left
        cookingTimeLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(cookingTimeLabel)
        
        cookingTimeDatePicker = UIDatePicker(frame: CGRect(x: 0, y: cookingTimeLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 100))
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
        //shortDescriptionTextView.delegate = self
        scrollView.addSubview(shortDescriptionTextView)
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: shortDescriptionTextView.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        pictureLabel.text = "Recipe image: "
        pictureLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        pictureLabel.textAlignment = .left
        scrollView.addSubview(pictureLabel)
        
        picturePicker = UIButton(frame: CGRect(x: 0, y: pictureLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: CGFloat(self.scrollView.bounds.width*(2.0/3.0))))
        picturePicker.backgroundColor = UIColor.lightGray
        picturePicker.addTarget(self, action: #selector(picturePickerButtonHandler(sender:)), for: .touchUpInside)
        picturePicker.imageView?.contentMode = .scaleAspectFit
        scrollView.addSubview(picturePicker)

        materialsLabel = UILabel(frame: CGRect(x: 0, y: picturePicker.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        materialsLabel.text = "Incredients: "
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
        // Init firestore
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // Storage
        storage = Storage.storage()
        storageRef = storage.reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set variables to old values
        /*
        if let recipeTitleTemp = (currentRecipe?.value(forKey: "recipeTitle") as! String) {
        	recipeTitle = recipeTitleTemp
        } else {
        	print("Something went wrong!")
        	recipeTitle = ""
        }
        
        if let recipeShortDescriptionTemp = (currentRecipe?.value(forKey: "recipeShortDescription") as! String) {
        	recipeShortDescription = recipeShortDescriptionTemp
        } else {
        	print("Something went wrong!")
        	recipeShortDescription = ""
   		}
   		
   		if let recipeMaterialsTemp = (currentRecipe?.value(forKey: "recipeMaterials") as! String) {
   			recipeMaterials = recipeMaterialsTemp
   		} else {
   			print("Something went wrong!")
   			recipeMaterials = ""
   		}
   		
   		if let recipeStepsTemp = (currentRecipe?.value(forKey: "recipeSteps") as! String) {
   			recipeSteps = recipeStepsTemp
   		} else {
   			print("Something went wrong!")
   			recipeSteps = ""
   		}
   		
   		if let recipeCookingTimeTemp = (currentRecipe?.value(forKey: "recipeSteps") as! Int) {
   			recipeCookingTime = recipeCookingTimeTemp
   		} else {
   			print("Something went wrong!")
   			recipeCookingTime = 0
   		}
   		
   		if let recipeMarkdownCodeTemp = (currentRecipe?.value(forKey: "recipeMarkdownCode") as! String) {
   			recipeMarkdownCode = recipeMarkdownCodeTemp
   		} else {
   			print("Something went wrong")
   		}
   		
        if let recipeImage = UIImage(data: Data(currentRecipe!.recipeImageBinaryData!)) {
   		} else {
   		    print("Something went wrong!")
            recipeImage = UIImage(named: "Gray")
   		}
 
        */
   		
        recipeTitle = (currentRecipe?.title)
        recipeShortDescription = (currentRecipe?.shortDescription)
        recipeMaterials = (currentRecipe?.materials)
        recipeSteps = (currentRecipe?.steps)
        recipeCookingTime = (currentRecipe?.cookingTime)
        recipeMarkdownCode = (currentRecipe?.markDownCode)
        recipeImage = (currentRecipe?.image)
        
        
        // update views
        titleTextField.text = recipeTitle!
        shortDescriptionTextView.text = recipeShortDescription!
        materialsTextView.text = recipeMaterials!
        stepsTextView.text = recipeSteps!
        picturePicker.setBackgroundImage(recipeImage, for: .normal)
        cookingTimeDatePicker.countDownDuration = TimeInterval(recipeCookingTime!*60)
        
    }
    
    @objc func picturePickerButtonHandler(sender: UIButton) {
        print("picturePicker pressed...")
        // get the image
        // initalice the imagePickerController
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

    @IBAction func saveButtonHandler(_ sender: UIBarButtonItem) {
        print("On save button pressed")
        
        currentRecipe?.title = titleTextField.text!
        currentRecipe?.shortDescription = shortDescriptionTextView.text!
        currentRecipe?.cookingTime = Int(cookingTimeDatePicker.countDownDuration / 60) // to get minutes
        if let image = picturePicker.image(for: .normal) {
            currentRecipe?.image = image
        } else {
            currentRecipe?.image = picturePicker.backgroundImage(for: .normal)!
        }
        currentRecipe?.materials = materialsTextView.text
        currentRecipe?.steps = stepsTextView.text
        let mdcode = markdownFormatter(recipeTitle: (currentRecipe?.title)!, recipeShortDescription: (currentRecipe?.shortDescription)!, recipeCookingTime: currentRecipe!.cookingTime, recipeMaterialsList: (currentRecipe?.materials)!, recipeStepsList: (currentRecipe?.steps)!, forPerson: 4)
        saveRecipe(title: currentRecipe!.title, shortDescription: currentRecipe!.shortDescription, cookingTime: currentRecipe!.cookingTime, image: currentRecipe!.image, materials: currentRecipe!.materials, steps: currentRecipe!.steps, recipeMarkDown: mdcode)
        currentRecipe?.markDownCode = mdcode
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveRecipe(title: String, shortDescription: String, cookingTime: Int, image: UIImage, materials: String, steps: String, isFavourite: Bool = false, recipeMarkDown: String) {
        // create document if document already exists under this title override document
        db.collection("recipes\(Auth.auth().currentUser!.uid)").document(title).setData([
            "title": title,
            "shortDescription": shortDescription,
            "cookingTime": cookingTime,
            "materials": materials,
            "steps": steps,
            "isFavourite": isFavourite,
            "md-code": recipeMarkDown
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        // storage
        let recipeFolderRef = storageRef.child("recipes\(Auth.auth().currentUser!.uid)")
        let recipeRef = recipeFolderRef.child(title) // create new folder
        let recipeTitleImageRef = recipeRef.child("titleImage.jpg")
        let newImage: UIImage
        if image.size.width > image.size.height {
            newImage = resizeImage(image: image, targetSize: CGSize(width: 900.0, height: 600.0)) // landscape
        } else {
            newImage = resizeImage(image: image, targetSize: CGSize(width: 600.0, height: 900.0)) // portrait
        }
        
        let uploadTask = recipeTitleImageRef.putData(Data(newImage.jpegData(compressionQuality: 1.0)!), metadata: nil) { (metadata, err) in
            if let err = err {
                print("Something went wrong \(err)")
            }
        }
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        print("On cancel button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDataset() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        recipes[currentRecipeIndex!] = currentRecipe!
        appDelegate.saveContext()
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecipeDetailViewController {
            destinationViewController.currentRecipe = currentRecipe
            destinationViewController.recipes = recipes
            destinationViewController.currentRecipeIndex = currentRecipeIndex
        }
    }*/
}

extension EditRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picturePicker.setImage(image, for: .normal)
        print("Updated image")
        dismiss(animated: true, completion: nil)
        
    }
}
