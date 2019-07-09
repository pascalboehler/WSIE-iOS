//
//  RoundedButton.swift
//  stopwatch
//
//  Created by Pascal Boehler on 11.02.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = frame.size.height / 2
    }

}
