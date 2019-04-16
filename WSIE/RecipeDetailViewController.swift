//
//  RecipeDetailViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import MarkdownView

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var markdownView: MarkdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markdownView.load(markdown: "# Hello World!")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        // quits the ViewController
        dismiss(animated: true, completion: nil)
    }
}

