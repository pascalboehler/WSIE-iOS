//
//  Utility.swift
//  WSIE
//
//  Created by Pascal Boehler on 20.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var completed = "----------------------------------------------"

func markdownFormatter(recipeTitle: String, recipeShortDescription: String, recipeCookingTime: Int, recipeMaterialsList: String, recipeStepsList: String, forPerson amount: Int16) -> String {
    let title = "# \(recipeTitle) \n"
    let amountOfPeople = "for \(amount) persons\n\n"
    let shortDescription = "## Description: \n"
    let shortDescriptionContent = "\(recipeShortDescription) \n"
    let cookingTime = "#### ***Time: \(recipeCookingTime) minutes***\n"
    let materials = "## Materials: \n"
    let materialsContent = getMaterials(recipeMaterialsList) + "\n"
    let steps = "## Steps: \n"
    let stepsContent = getSteps(recipeStepsList) + "\n"
    
    return title + amountOfPeople + cookingTime + shortDescription + shortDescriptionContent + materials + materialsContent + steps + stepsContent
}

func getMaterials(_ materials: String) -> String {
    var formattedMaterials: String = "* "
    
    for char in materials {
        if char == "\n" {
            formattedMaterials += "\n* "
        } else {
            formattedMaterials += String(char)
        }
    }
    
    return formattedMaterials
}

func getSteps(_ steps: String) -> String {
    var formattedSteps: String = "* "
    
    for char in steps {
        if char == "\n" {
            formattedSteps += "\n* "
        } else {
            formattedSteps += String(char)
        }
    }
    
    return formattedSteps
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
