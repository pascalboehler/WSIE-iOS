//
//  EditRecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 17.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Add all the additional elements to the view
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width - 16, height: 1000)
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
        
        cookingTimeLabel = UILabel(frame: CGRect(x: 0, y: titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50)
        cookingTimeLabel.text = "Cooking time: "
        cookingTimeLabel.textAlignment = .left
        cookingTimeLabel.font = UIFont.systemFont(ofSize(25, weight: .semibold)
        scrollView.addSubview(cookingTimeLabel)
        
        cookingTimeDatePicker = UIDatePicker(frame: CGRect(x: 0, y: cookingTimeLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: )	
        cookingTimeDatePicker.datePickerMode = .countDownTimer
        cookingTimeDatePicker.minuteInterval = 1
        scrollView.addSubview(cookingTimeDatePicker)
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        pictureLabel.text = "Recipe image: "
        pictureLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        pictureLabel.textAlignment = .left
        scrollView.addSubview(pictureLabel)
        
        picturePicker = UIButton(frame: CGRect(x: 0, y: pictureLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: CGFloat(self.scrollView.bounds.width*(2.0/3.0))))
        picturePicker.backgroundColor = UIColor.lightGray
        picturePicker.addTarget(self, action: #selector(picturePickerButtonHandler(sender:)), for: .touchUpInside)
        scrollView.addSubview(picturePicker)

        materialsLabel = UILabel(frame: CGRect(x: 0, y: picturePicker.frame.maxY + 8, width: Int(self.scrollView.bounds.width), height: 50))
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set variables to old values
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
   		
   		if let recipeImage = UIImage(data; Data(currentRecipe!.recupeImageBinaryData!)) {
   		} else {
   		    print("Something went wrong!")
   		    recipeImage = UIImage(names: "Gray")
   		}
   	 
   		/*
        recipeTitle = (currentRecipe?.value(forKey: "recipeTitle") as! String)
        recipeShortDescription = (currentRecipe?.value(forKey: "recipeShortDescription") as! String)
        recipeMaterials = (currentRecipe?.value(forKey: "recipeMaterials") as! String)
        recipeSteps = (currentRecipe?.value(forKey: "recipeSteps") as! String)
        recipeCookingTime = (currentRecipe?.value(forKey: "recipeCookingTime") as! Int)
        recipeMarkdownCode = (currentRecipe?.value(forKey: "recipeMarkdownCode") as! String)
        recipeImage = UIImage(data: Data(currentRecipe!.recipeImageBinaryData!))
        */
        
        // update views
        titleTextField.text = recipeTitle!
        // shortDescriptionTextView.text = recipeShortDescription!
        materialsTextView.text = recipeMaterials!
        stepsTextView.text = recipeSteps!
        picturePicker.setBackgroundImage(recipeImage, for: .normal)
        
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
        currentRecipe?.recipeTitle = titleTextField.text
        currentRecipe?.recipeShortDescription = shortDescriptionTextView.text
        // currentRecipe?.recipeCookingTime =
        currentRecipe?.recipeImageBinaryData = NSData(data: Data((picturePicker.backgroundImage(for: .normal)?.jpegData(compressionQuality: 1.0))!)) as Data
        currentRecipe?.recipeMaterials = materialsTextView.text
        currentRecipe?.recipeSteps = stepsTextView.text
        currentRecipe?.recipeMarkdownCode = markdownFormatter(recipeTitle: (currentRecipe?.recipeTitle)!, recipeShortDescription: (currentRecipe?.recipeShortDescription)!, recipeCookingTime: 10, recipeMaterialsList: (currentRecipe?.recipeMaterials)!, recipeStepsList: (currentRecipe?.recipeSteps)!)
        updateDataset()
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
}

extension EditRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picturePicker.setBackgroundImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
}
