//
//  IdeasViewController.swift
//  WSIE
//
//  Created by Pascal Boehler on 15.04.19.
//  Copyright © 2019 Pascal Boehler. All rights reserved.
//

import UIKit

class IdeasViewController: UIViewController {

    @IBOutlet weak var ideaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonHandler(_ sender: UIButton) {
        print("Button pressed!")
        performSegue(withIdentifier: "ShowOurRecommendationViewController", sender: nil)
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
