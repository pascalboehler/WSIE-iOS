//
//  LoginViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            print("Handler added")
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        print("On login button pressed")
        guard let email = emailTextField.text else {
            print("Error no email entered")
            return
        }
        guard let password = passwordTextField.text else {
            print("No password entered")
            return
        }
        
        // [START headless_email_auth]
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error != nil {
                print("Something happened \(error)")
            } else {
                print("Successfully logged in")
                /*let user = Auth.auth().currentUser
                print(user!.uid)
                print(user!.email!)*/
                self.performSegue(withIdentifier: "showMainApplication", sender: nil)
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

}
