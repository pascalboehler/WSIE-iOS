//
//  ShoppingListItemTableViewCell.swift
//  WSIE
//
//  Created by Pascal Boehler on 19.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class ShoppingListItemTableViewCell: UITableViewCell {

    @IBOutlet var itemName: UILabel!
    var indexPath: IndexPath!
    
    @IBAction func checkBoxButtonValueChanged(_ sender: CheckboxButton) {
        print("On Checkbox pressed")
        if sender.on {
            print("ON")
        } else {
            print("OFF")
        }
    }
    
    
}
