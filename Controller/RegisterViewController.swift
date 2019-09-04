//
//  RegisterViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 1/30/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var promptMessageText: UILabel!
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        if (firstNameText.text != "" || lastNameText.text != "" || userNameText.text != "" || passwordText.text != "" ){
        
        Auth.auth().createUser(withEmail: userNameText.text!, password: passwordText.text!) { (user, error) in
           
            if error != nil {
                print(error!)
            }
            else{
                print("Registration succesful")
                
                let userDB = Database.database().reference().child("Users")
                
                let userID = Auth.auth().currentUser!.uid
                
                let postDictionary = ["userName": Auth.auth().currentUser?.email, "firstName": self.firstNameText.text!, "lastName": self.lastNameText.text!, "userID": userID]
                
                userDB.child(userID).setValue(postDictionary){
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    }
                        
                    else {print("User successfully saved")}

                   self.performSegue(withIdentifier: "gotoMain", sender: self)
                
                }
                
            }
            
        }
            
        }
        
        else {promptMessageText.text = "Please fill in all required fields"}
    }
    
}


