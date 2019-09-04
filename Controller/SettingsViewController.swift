//
//  SettingsViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 1/30/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableRows = ["About","Notifications","Logout"]
    
    let segueArray = ["gotoAbout", "gotoNotifications"]
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTable.delegate = self
        settingsTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        cell.textLabel!.text = tableRows[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 2 {
            performSegue(withIdentifier: segueArray[indexPath.row], sender: self)
        }
        
        else {
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Logout", style: .default) { (action) in
                
                do{
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                }
                    
                catch{
                    print("There was an error signing out!")
                }
            }
            
            let action2 = UIAlertAction(title: "No", style: .default) { (action) in
                
            }
            
            alert.addAction(action)
            alert.addAction(action2)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }


}
