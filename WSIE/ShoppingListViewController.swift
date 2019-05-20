//
//  ShoppingListViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 19.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData

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
    @IBOutlet weak var textView: UITextField!
    
    var shoppingList: [ShoppingList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // setup nav bar button
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonHandler))
        navigationBar.topItem?.rightBarButtonItem = button
        barButtonStatus = .add
        
        // Load data from db
        shoppingList = fetchData()
        // reload the tableView's data
        tableView.reloadData()
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
    @IBAction func addNewItemButtonHandler(_ sender: Any) {
        if let newItem = textView.text {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "ShoppingList", in: managedContext)!
            
            let item = NSManagedObject(entity: entity, insertInto: managedContext)
            
            item.setValue(newItem, forKey: "name")
            item.setValue(1, forKey: "amount")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save recipe. \(error), \(error.userInfo)")
            }
            shoppingList = fetchData()
            tableView.reloadData()
            textView.text = ""
        } else {
            print("Error!!!")
        }
    }
    
    // get the data from db
    func fetchData() -> [ShoppingList]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        return []
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemTableViewCell") as! ShoppingListItemTableViewCell
        // create data
        cell.itemName.text = "\(shoppingList[indexPath.row].name ?? "Not available") \(shoppingList[indexPath.row].amount)x"
        // store indexpath inside cell
        cell.indexPath = indexPath
        
        return cell
    }
    
}
