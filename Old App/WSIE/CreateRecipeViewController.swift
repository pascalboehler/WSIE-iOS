//
//  CreateRecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CreateRecipeViewController: UIViewController {
    
    var titleLabel: UILabel!
    var titleTextField: UITextField!
    var shortDescriptionLabel: UILabel!
    var shortDescriptionTextView: UITextView!
    var personAmountLabel: UILabel!
    var personAmountCounter: UIPickerView!
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
    
    var db: Firestore!
    var storage: Storage!
    var storageRef: StorageReference!
    
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
        
        personAmountLabel = UILabel(frame: CGRect(x: 0, y: self.titleTextField.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        personAmountLabel.text = "For persons: "
        personAmountLabel.textAlignment = .left
        personAmountLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(personAmountLabel)
        
        personAmountCounter = UIPickerView(frame: CGRect(x: 0, y: personAmountLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
        personAmountCounter.delegate = self
        personAmountCounter.dataSource = self
        scrollView.addSubview(personAmountCounter)
        
        cookingTimeLabel = UILabel(frame: CGRect(x: 0, y: personAmountCounter.frame.maxY + 8, width: self.scrollView.bounds.width, height: 50))
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
        shortDescriptionTextView.delegate = self
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
        materialsLabel.text = "Incredients: "
        materialsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        materialsLabel.textAlignment = .left
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
        stepsLabel.textAlignment = .left
        scrollView.addSubview(stepsLabel)
        
        stepsTextView = UITextView(frame: CGRect(x: 0, y: stepsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        stepsTextView.isEditable = true
        stepsTextView.autocapitalizationType = .sentences
        stepsTextView.autocorrectionType = .default
        stepsTextView.delegate = self
        scrollView.addSubview(stepsTextView)
        
        // Do any additional setup after loading the view.
        // Firebase setup
        // init db
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // init storage service
        storage = Storage.storage()
        storageRef = storage.reference()
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
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        showSaveAlert()
        // self.dismiss(animated: true, completion: nil)
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
        
        let personAmount = personAmountCounter.selectedRow(inComponent: 0) + 1
        
        let cookingTime = Int(cookingTimeDatePicker.countDownDuration) / 60
        
        
        if let imageTemp = picturePicker.currentBackgroundImage{
            // nothing happens
            image = imageTemp
        } else {
            print("Could not find background image...")
            image = UIImage(named: "Gray")!
        }
        
        /*
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Cast to imageData went wrong")
            return
        }*/
        
        guard let materials = materialsTextView.text else {
            return
        }
        
        guard let steps = stepsTextView.text else {
            return
        }
        
        let recipeMarkDown = markdownFormatter(recipeTitle: title, recipeShortDescription: shortDescription, recipeCookingTime: cookingTime, recipeMaterialsList: materials, recipeStepsList: steps, forPerson: Int16(personAmount))
        
        print(recipeMarkDown)
        
        saveRecipe(title: title, shortDescription: shortDescription, cookingTime: cookingTime, image: image, materials: materials, steps: steps, recipeMarkDown: recipeMarkDown, forPerson: personAmount)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Firebase version
    func saveRecipe(title: String, shortDescription: String, cookingTime: Int, image: UIImage, materials: String, steps: String, isFavourite: Bool = false, recipeMarkDown: String, forPerson: Int) {
        print("Executed!")
        // db
        // create document if document already exists under this title override document NO VALIDATION!!!!
        db.collection("recipes\(Auth.auth().currentUser!.uid)").document(title).setData([
            "title": title,
            "shortDescription": shortDescription,
            "cookingTime": cookingTime,
            "materials": materials,
            "steps": steps,
            "isFavourite": isFavourite,
            "md-code": recipeMarkDown,
            "userId": Auth.auth().currentUser!.uid, // store the user who created doc
            "public": false, // for later use
            "forPerson": forPerson
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
        
        _ = recipeTitleImageRef.putData(Data(newImage.jpegData(compressionQuality: 1.0)!), metadata: nil) { (metadata, err) in
            if let err = err {
                print("Something went wrong \(err)")
            }
        }
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
            
            let personAmount = self.personAmountCounter.selectedRow(inComponent: 0) + 1
            
            guard let imageLink = self.picturePicker.currentImage else {
                // self.missingElementAlert(forElement: "imageLink")
                return
            }
            
            /*
            guard let imageData = imageLink.jpegData(compressionQuality: 1.0) else {
                // self.missingElementAlert()
                return
            }*/
            
            guard let materials = self.materialsTextView.text else {
                self.missingElementAlert(forElement: "materials")
                return
            }
            
            guard let steps = self.stepsTextView.text else {
                self.missingElementAlert(forElement: "steps")
                return
            }
            
            self.saveRecipe(title: title, shortDescription: shortDescription, cookingTime: cookingTime, image: imageLink, materials: materials, steps: steps, recipeMarkDown: "", forPerson: personAmount)
            
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


extension CreateRecipeViewController : UITextViewDelegate {
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }*/
}

extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picturePicker.setBackgroundImage(image, for: .normal)
        print("Updated image")
        dismiss(animated: true, completion: nil)
        
    }
}

extension CreateRecipeViewController: UIPickerViewDelegate {
    
}

extension CreateRecipeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
