//
//  LoginViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 08.07.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            return
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func LoginButtonHandler(_ sender: Any) {
        print("On login button pressed")
        guard let email = emailTextField.text else {
            print("Insert an email addr.")
            return
        }
        guard let password = passwordTextField.text else {
            print("Please enter your password!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
            if let err = err {
                // print("Something went wrong while logging in user with error: \(err)")
                let userOrPasswordInvalidAlert = UIAlertController(title: "Unable to sign in user", message: err.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                userOrPasswordInvalidAlert.addAction(okAction)
                self.present(userOrPasswordInvalidAlert, animated: true, completion: nil)
            } else {
                // print("Successfully logged in user")
                self.performSegue(withIdentifier: "showTabBarViewController", sender: nil)
            }
        }
    }
    
    @IBAction func SignUpButtonHandler(_ sender: Any) {
        print("On sign up button pressed")
        guard let email = emailTextField.text else {
            print("Insert an email addr.")
            return
        }
        guard let password = passwordTextField.text else {
            print("Please choose a password")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // print("Something went wrong while signing up new user with error \(error)")
                let userExistsAlert = UIAlertController(title: "Error signing up new user", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                userExistsAlert.addAction(okAction)
                self.present(userExistsAlert, animated: true, completion: nil)
            } else {
                // print("Successfully created new user")
                self.performSegue(withIdentifier: "showTabBarViewController", sender: nil)
            }
        }
    }
}
