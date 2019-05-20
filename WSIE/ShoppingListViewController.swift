//
//  ShoppingListViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 19.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

enum BarButtonStatus {
    case add, done
}

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemViewFullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addItemViewZeroHeightConstraint: NSLayoutConstraint!
    var addItemViewIsVisible = false
    @IBOutlet weak var navigationBar: UINavigationBar!
    var barButtonStatus: BarButtonStatus = .add
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonHandler))
        navigationBar.topItem?.rightBarButtonItem = button
        barButtonStatus = .add
    }

    @objc func addItemButtonHandler() {
        print("On add button pressed!")
        if barButtonStatus == .add {
            if addItemViewIsVisible == false {
                addItemViewZeroHeightConstraint.isActive = false
                addItemViewFullHeightConstraint.isActive = true
                let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addItemButtonHandler))
                navigationBar.topItem?.rightBarButtonItem = button
                barButtonStatus = .done
                addItemViewIsVisible = true
            } else {
                return
            }
        } else if barButtonStatus == .done {
            if addItemViewIsVisible == true {
                // hide addItemView
                addItemViewFullHeightConstraint.isActive = false
                addItemViewZeroHeightConstraint.isActive = true
                // change button back to add
                let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonHandler))
                navigationBar.topItem?.rightBarButtonItem = button
                barButtonStatus = .add
                addItemViewIsVisible = false
            } else {
                return
            }
        }
        
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
