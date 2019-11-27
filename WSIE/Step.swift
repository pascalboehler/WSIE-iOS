//
//  Step.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.11.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation

struct Step: Hashable, Codable, Identifiable {
    var id: Int
    var description: String
    var image: String // change later to image + if none no image is set
}
