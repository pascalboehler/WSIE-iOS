//
//  SignUpViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwortTextField: UITextField!
    
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

    @IBAction func signUpButtonHandler(_ sender: UIButton) {
        print("On sign up button pressed")
        guard let email = emailTextField.text else {
            print("Error no email entered")
            return
        }
        guard let password = passwortTextField.text else {
            print("No password entered")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("An error occured! \(error)")
            } else {
                print("User successfully logged in!")
                self.performSegue(withIdentifier: "showMainApplication", sender: nil)
            }
        } // create a new user
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
