//
//  SettingsViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 06.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var iCloudBackupSwitch: UISwitch!
    @IBOutlet weak var dataEncryptionSwitch: UISwitch!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    var dataset: [Settings]! // preferences
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataset = fetchData()
        // set VC back to old states
        iCloudBackupSwitch.setOn(dataset[0].iCloudSyncIsEnabled, animated: true)
        dataEncryptionSwitch.setOn(dataset[0].dataEncryptionIsEnabled, animated: true)
        touchIDSwitch.setOn(dataset[0].touchIdIsEnabled, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func externalDatasourcesButtonHandler(_ sender: Any) {
        print("On external datasource button pressed")
    }
    
    @IBAction func signOutButtonHandler(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("SOMETHING WENT WRONG: ")
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
    // get the data from db
    func fetchData() -> [Settings]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Settings>(entityName: "Settings")
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
