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
    let amountOfPeople = "for \(amount) persons"
    let shortDescription = "## Description: \n"
    let shortDescriptionContent = "\(recipeShortDescription) \n"
    let cookingTime = "Time: \(recipeCookingTime) minutes\n"
    let materials = "## Materials: \n"
    let materialsContent = getMaterials(recipeMaterialsList) + "\n"
    let steps = "## Steps: \n"
    let stepsContent = getSteps(recipeStepsList) + "\n"
    
    return title + amountOfPeople + shortDescription + shortDescriptionContent + cookingTime + materials + materialsContent + steps + stepsContent
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
