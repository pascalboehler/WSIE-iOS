//
//  TabBarViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 11.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedIndex = 2 // make IdeaVC first displayed item
        
        if Auth.auth().currentUser?.uid == nil {
            self.performSegue(withIdentifier: "showLoginViewController", sender: nil)
        }
    }
    
}
