//
//  AppDelegate.swift
//  WSIE
//
//  Created by Pascal Boehler on 16.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItemToProcess: UIApplicationShortcutItem!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase stuff
        FirebaseApp.configure() // configure the Firebase instance
        let db = Firestore.firestore() // get the database for recipe data
        let storage = Storage.storage() // get the storage service for recipe images
        print(db) // silence warnings
        print(storage) // silence warnings
        
        // Quick Actions:
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        // window stuff
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser?.uid != nil { // user IS logged in
            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarViewController
            window?.rootViewController = tabBarController
            
        } else { // user IS NOT logged on
            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            window?.rootViewController = loginViewController
        }

        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Application launched")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // check if a value for settings is set
        let settings = fetchSettingsData() // get the settings
        if settings == [] { // if settings is not set, set default values => this should only be executed once when application is installeds
            let managedContext = persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)!
            
            let item = NSManagedObject(entity: entity, insertInto: managedContext)
            item.setValue(false, forKey: "iCloudSyncIsEnabled")
            item.setValue(true, forKey: "dataEncryptionIsEnabled")
            item.setValue(false, forKey: "touchIdIsEnabled")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save recipe. \(error), \(error.userInfo)")
            }

        }
        
        if let shortcutItem = shortcutItemToProcess {
            print(shortcutItem.type)
            if shortcutItem.type == "FavouritesAction" {
                if let window = self.window, let rootViewController = window.rootViewController  as? TabBarViewController {
                    var currentController = rootViewController
                    currentController.selectedIndex = 3
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WSIE")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // get the data from db
    func fetchSettingsData() -> [Settings]{
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
    
    // get the data from db
    /*
    func fetchRecipeData() -> [Recipe]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Recipe>(entityName: "Settings")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        return []
    } */
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
}

