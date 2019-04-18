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
    
    // IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    // variables
    var currentRecipe: Recipe!
    
    var recipeTitle: String?
    var recipeShortDescription: String?
    var recipeMaterials: String?
    var recipeSteps: String?
    var recipeImageLink: String?
    var recipeCookingTime: Int?
    var recipePreparationtime: Int?
    var recipeMarkdownCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.title = "Edit Recipe"
        self.navigationController?.navigationBar.prefersLargeTitles = true*/
    
        // Add all the additional elements to the view
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1000)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 50))
        titleLabel.text = "Recipe title: "
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        scrollView.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: 0, y: 58, width: self.scrollView.bounds.width, height: 30))
        titleTextField.placeholder = "Insert a title for the recipe"
        self.scrollView.addSubview(titleTextField)
        
        pictureLabel = UILabel(frame: CGRect(x: 0, y: 91, width: self.scrollView.bounds.width, height: 50))
        pictureLabel.text = "Recipe image: "
        pictureLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        pictureLabel.textAlignment = .center
        scrollView.addSubview(pictureLabel)
        
        picturePicker = UIButton(frame: CGRect(x: 0, y: 154, width: self.scrollView.bounds.width, height: CGFloat(self.scrollView.bounds.width*(2.0/3.0))))
        picturePicker.backgroundColor = UIColor.lightGray
        picturePicker.addTarget(self, action: #selector(picturePickerButtonHandler(sender:)), for: .touchUpInside)
        scrollView.addSubview(picturePicker)

        materialsLabel = UILabel(frame: CGRect(x: 0, y: Int(154 + Int(self.picturePicker.bounds.height)), width: Int(self.scrollView.bounds.width), height: 50))
        materialsLabel.text = "Materials: "
        materialsLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        materialsLabel.textAlignment = .center
        scrollView.addSubview(materialsLabel)
        
        materialsTextView = UITextView(frame: CGRect(x: 0, y: materialsLabel.frame.maxY + 8, width: self.scrollView.bounds.width, height: 150))
        materialsTextView.isEditable = true
        materialsTextView.autocapitalizationType = .sentences
        materialsTextView.autocorrectionType = .default
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
        scrollView.addSubview(stepsTextView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set variables to old values
        /*
        recipeTitle = (currentRecipe.value(forKey: "recipeTitle") as! String)
        recipeShortDescription = (currentRecipe?.value(forKey: "recipeShortDescripton") as! String)
        recipeMaterials = (currentRecipe.value(forKey: "recipeMaterials") as! String)
        recipeSteps = (currentRecipe.value(forKey: "recipeSteps") as! String)
        recipeCookingTime = (currentRecipe.value(forKey: "recipeCookingTime") as! Int)
        recipeMarkdownCode = (currentRecipe.value(forKey: "recipeMarkdownCode") as! String)
        
        // update views
        titleTextField.text = recipeTitle!
        // shortDescriptionTextView.text = recipeShortDescription!
        materialsTextView.text = recipeMaterials!
        stepsTextView.text = recipeSteps! */
        
        
        
    }
    
    @objc func picturePickerButtonHandler(sender: UIButton) {
        print("picturePicker pressed...")
    }

    @IBAction func saveButtonHandler(_ sender: UIBarButtonItem) {
        print("On save button pressed")
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        print("On cancel button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
