//
//  EditRecipeView.swift
//  WSIE
//
//  Created by Pascal Boehler on 13.01.20.
//  Copyright © 2020 Pascal Boehler. All rights reserved.
//

import SwiftUI
import Firebase

struct EditRecipeView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State var recipe: Recipe
    /*
    @State var titletextFieldTitle = ""
    @State var shortDescriptionTextFieldText = ""
    @State var personAmountValue = 4
    @State var timeNeeded = 12
    @State var ingredients: [AddIngredient] = []
    @State var steps: [Step] = []
    @State var supportedUnits = ["Unset", "Gramm", "Kilogramm", "Liter", "Milliliter"]
    */
    // Pickers:
    // Ingredients
    @State var showUnitPicker = false
    @State var unitIndex: Int = 0
    @State var currentIngredientIndex = 0
    @State var showPersonAmountPicker = false
    @State var showTimePicker = false
    @State var timeNeeded = 12
    @State var ingredients: [AddIngredient] = []
    @State var supportedUnits = ["Unset", "Gramm", "Kilogramm", "Liter", "Milliliter"]
    
    var body: some View {
        VStack {
            ScrollView {
                Group { // Title TF
                    TextField("Insert title", text: $recipe.title)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                
                Divider()
                
                // Add Image
                Button(action: {
                    print("New Image button pressed")
                }) {
                    Image("AddImage")
                        .resizable()
                        .aspectRatio(3/2, contentMode: .fit)
                }
                    .overlay(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(Color.gray, lineWidth: 2)
                    )
                    .cornerRadius(25)
                    .buttonStyle(PlainButtonStyle())
                
                // Add person amount & set time
                HStack {
                    Button(action: {
                        print("set person amount button pressed")
                    }) {
                        Text("For \(recipe.personAmount) person")
                    }
                    Spacer()
                    Button(action: {
                        print("Set time button pressed")
                    }) {
                        Image(systemName: "clock")
                        Text("\(timeNeeded) min")
                    }
                    
                }
                
                Divider()
                
                TextField("Add short description", text: $recipe.shortDescription)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                Divider()
                
                // Add Ingredients
                Group {
                    Text(NSLocalizedString("Ingredients needed", comment: "Title for ingredients list"))
                        .fontWeight(.bold)
                        .padding()
                    
                    ForEach(ingredients.indices, id: \.self) { index in
                        HStack {
                            TextField("4000", text: self.$ingredients[index].amount)
                                .frame(width: 44)
                            
                            Button(action: {
                                self.currentIngredientIndex = index
                                self.showUnitPicker = true
                            }) {
                                Text("\(self.ingredients[index].unit)")
                            }
                            Spacer()
                            TextField("Enter ingredient here", text: self.$ingredients[index].name)
                        }
                    }.onDelete { (offset) in
                        self.ingredients.remove(atOffsets: offset)
                    }
                    Button(action: {
                        self.ingredients.append(AddIngredient(id: self.ingredients.count + 1, name: "Enter ingredient here", amount: "4000", unit: "Unit"))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Spacer()
                            Text(NSLocalizedString("Add Ingredient", comment: "Add ingredient button title"))
                        }
                    }
                }
                
                Divider()
                
                // Add Steps
                Group {
                    Text(NSLocalizedString("Steps to prepare", comment: "Title for steps list"))
                        .fontWeight(.bold)
                        .padding()
                    
                    ForEach(recipe.steps.indices, id: \.self) { index in
                        /*
                         Button(action: {
                             print("New Image button pressed")
                         }) {
                             Image("AddImage")
                                 .resizable()
                                 .aspectRatio(3/2, contentMode: .fit)
                         }
                             .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray, lineWidth: 2)
                             )
                             .cornerRadius(25)
                             .buttonStyle(PlainButtonStyle())
                         */
                        VStack {
                            Text(String.localizedStringWithFormat(NSLocalizedString("Step %d", comment: "Step title label"), (index + 1)))
                            TextField("Add step description", text: self.$recipe.steps[index].description)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                    }.onDelete { (offset) in
                        self.recipe.steps.remove(atOffsets: offset)
                    }
                    
                    Button(action: {
                        self.recipe.steps.append(Step(id: self.recipe.steps.count + 1, description: "Enter step description here.", image: "none"))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Spacer()
                            Text(NSLocalizedString("Add step", comment: "Add step button title"))
                        }
                    }
                }
                
                    
                    
            }
            if (showUnitPicker) {
                VStack {
                    HStack {
                        Button(action: {
                            self.showUnitPicker = false
                        }) {
                            Text(NSLocalizedString("Cancel", comment: "Cancel button text"))
                        }
                        Spacer()
                        Button(action: {
                            self.showUnitPicker = false
                            self.ingredients[self.currentIngredientIndex].unit = self.supportedUnits[self.unitIndex]
                        }) {
                            Text(NSLocalizedString("Done", comment: "Done button text"))
                        }
                    }
                    Picker(selection: $unitIndex, label: Text("")) {
                        ForEach(0 ..< supportedUnits.count) { i in
                            Text(self.supportedUnits[i])
                        }
                    }
                }
            }
            
            if (showPersonAmountPicker) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showPersonAmountPicker = false
                        }) {
                            Text(NSLocalizedString("Done", comment: "Done button text"))
                        }
                    }
                    Picker(selection: $recipe.personAmount, label: Text("")) {
                        ForEach(0 ..< 200) { i in
                            Text("\(i)")
                        }
                    }
                }
            }
            
            if (showTimePicker) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showTimePicker = false
                        }) {
                            Text(NSLocalizedString("Done", comment: "Done button text"))
                        }
                    }
                    Picker(selection: $timeNeeded, label: Text("Time needed")) {
                        ForEach(0 ..< 2000) { i in
                            Text("\(i) min")
                        }
                    }
                }
            }
            
        }
            .padding()
            .navigationBarTitle(Text(NSLocalizedString("New Recipe", comment: "View title Create Recipe View")))
            .navigationBarItems(trailing:
                Button(action: {
                    var recipeIngredients: [Ingredient] = []
                    for item in self.ingredients {
                        recipeIngredients.append(Ingredient(id: item.id, name: item.name, amount: Int(item.amount) ?? 1, unit: item.unit))
                    }
                    /*let recipe = Recipe(id: nil, title: self.titletextFieldTitle, timeNeeded: "\(self.timeNeeded) min", isFavourite: false, ingredients: recipeIngredients, steps: self.steps, shortDescription: self.shortDescriptionTextFieldText, uid: Auth.auth().currentUser!.uid, imageName: "NoPhoto", personAmount: self.personAmountValue, sharedWith: [], language: Bundle.preferredLocalizations(from: Utility.applicationSupportedLanguages).first!, isPublic: false, imageData: UIImage(named: "NoPhoto")!.jpegData(compressionQuality: 0.25)!)
                    self.networkManager.createNewRecipe(recipe: recipe)
                    self.titletextFieldTitle = ""
                    self.shortDescriptionTextFieldText = ""
                    self.timeNeeded = 0
                    self.steps = []
                    self.ingredients = []
                    self.personAmountValue = 4*/
                    self.networkManager.createNewRecipe(recipe: recipe)
                    
                }) {
                    Text(NSLocalizedString("Done", comment: "Save button"))
                }
            )
    }
}

struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRecipeView(recipe: recipeData[0])
    }
}

