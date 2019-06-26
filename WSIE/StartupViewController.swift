//
//  StartupViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 26.06.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit
import Firebase

class StartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This should be printed second")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("quitted vc")
            performSegue(withIdentifier: "showMainApplication", sender: nil)
            //dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func SignInButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "showLoginViewController", sender: nil)
    }
    
    @IBAction func signUpButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "showSignUpViewController", sender: nil)
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
