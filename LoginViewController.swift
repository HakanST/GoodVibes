//
//  LoginViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 1/30/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
   
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { (user, error) in

            if error != nil {
                print(error!)
            }

            else{
                print("Login succesful!")
                self.performSegue(withIdentifier: "gotoMain", sender: self)
            }
        }
        

        
    }


}
