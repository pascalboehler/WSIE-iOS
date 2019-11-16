//
//  ShoppingListViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 19.05.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

enum BarButtonStatus {
    case add, done
}

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemViewFullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addItemViewZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var additemViewFullBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addItemViewZeroBottomConstraint: NSLayoutConstraint!
    var addItemViewIsVisible = false
    @IBOutlet weak var navigationBar: UINavigationBar!
    var barButtonStatus: BarButtonStatus = .add
    @IBOutlet weak var textView: UITextField!
    
    var shoppingList: [ShoppingList] = []
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        textView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // setup nav bar button
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonHandler))
        navigationBar.topItem?.rightBarButtonItem = button
        barButtonStatus = .add
        
        // Load data from db
        //shoppingList = fetchData()
        // reload the tableView's data
//        shoppingList = []
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        appDelegate.saveContext()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        tableView.reloadData()
        fetchDataAndAddToTableView()
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
                // end editing
                textView.endEditing(true) // hides keyboard when textView disappears
                // hide addItemView
                addItemViewFullHeightConstraint.isActive = false
                addItemViewZeroHeightConstraint.isActive = true
                // change button back to add
                let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonHandler))
                navigationBar.topItem?.rightBarButtonItem = button
                barButtonStatus = .add
                addItemViewIsVisible = false
                textView.endEditing(true) // end editing to hide the keyboard => then it disappears...
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
    
    // OLD FUNCS:
    /*
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
    
    func updateDataset() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.saveContext()
    }
    
    @IBAction func filterButtonHandler(_ sender: Any) {
        
    }
 */
    // New funcs:
    
    @IBAction func addNewItemButtonHandler(_ sender: Any) {
        guard let itemName = textView.text else {
            // show alert (insert text
            return
        }
        db.collection("shoppingList\(Auth.auth().currentUser!.uid)").document(itemName).setData([
            "name": itemName,
            "bought": false
        ]) { err in
            if let err = err {
                print("Something went wrong with error: \(err)")
                self.fetchDataAndAddToTableView()
                self.textView.text = ""
            }
        }
    }
    
    func updateDataset(atIndex index: Int) {
        db.collection("shoppingList\(Auth.auth().currentUser!.uid)").document(shoppingList[index].name).updateData([
            "name": shoppingList[index].name,
            "bought": shoppingList[index].bought
        ]) { err in
            if let err = err {
                print("Could not update element! Failed with error: \(err)")
            } else {
                self.fetchDataAndAddToTableView()
            }
        }
        
    }
    
    func deleteDataset(atIndex index: Int) {
        db.collection("shoppingList\(Auth.auth().currentUser!.uid)").document(shoppingList[index].name).delete { (err) in
            if let err = err {
                print("Something went wrong with error: \(err)")
                return
            } else {
                self.fetchDataAndAddToTableView()
            }
        }
    }
    
    func fetchDataAndAddToTableView() {
        // get data
        shoppingList = []
        db.collection("shoppingList\(Auth.auth().currentUser!.uid)").getDocuments { (snapshot, err) in
            if let err = err {
                print("Something went wrong while fetching data with error: \(err)")
            } else {
                if let docs = snapshot?.documents {
                    for element in docs {
                        let shoppingListElement: ShoppingList = ShoppingList(bought: element.data()["bought"] as! Bool, name: element.data()["name"] as! String)
                        self.shoppingList.append(shoppingListElement)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemTableViewCell") as! ShoppingListItemTableViewCell
        // create data
        cell.itemName.text = "\(shoppingList[indexPath.row].name)"
        if shoppingList[indexPath.row].bought == true {
            cell.itemIsCompleted.text = completed // to strikethrough
        } else {
            cell.itemIsCompleted.text = ""
        }
        
        return cell
    }
    
}


extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("On tableView pressed")
        shoppingList[indexPath.row].bought = !shoppingList[indexPath.row].bought
        tableView.reloadData()
        updateDataset(atIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDataset(atIndex: indexPath.row)
        }
    }
}

extension ShoppingListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield did begin editing") // go up 216 pts
        addItemViewZeroBottomConstraint.isActive = false
        addItemViewFullHeightConstraint.isActive = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Textfield did end editing") // go down
        addItemViewFullHeightConstraint.isActive = false
        addItemViewZeroBottomConstraint.isActive = true
    }
}
