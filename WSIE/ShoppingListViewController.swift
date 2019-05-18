//
//  ShoppingListViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 18.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stockButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "ShowStockViewController", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
