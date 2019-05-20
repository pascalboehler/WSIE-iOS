//
//  ShoppingListViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 19.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addItemButtonHandler(_ sender: Any) {
        print("On add button pressed!")
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

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemTableViewCell") as! ShoppingListItemTableViewCell
        cell.itemName.text = "Test"
        
        return cell
    }
    
    
}
