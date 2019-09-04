//
//  AboutViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 1/31/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {


    @IBOutlet weak var aboutLabel: UILabel!
    
   override func viewDidLoad() {
        super.viewDidLoad()
        aboutLabel.text = "An App that allows users to share their positive encounters."

    }
    


}
