//
//  CreateRecipeViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class CreateRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonHandler(_ sender: Any) {
        print("On Cancel Button Pressed")
        self.removeFromParent()
    }
    
    @IBAction func saveButtonHandler(_ sender: Any) {
        print("OnSaveButtonPressed")
        self.removeFromParent()
    }
    
}
