//
//  PostReply.swift
//  FIH
//
//  Created by Hakan Turgut on 2/19/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import Foundation
import Firebase

class Comment{
    
    var ID = String()
    var OPID = String()
    
    var userID = String()
    var userName = String()
    
    var Body = String()
    var Likes = Int() //
    var timeStamp = String()
    var Anonymous: Bool = false

    
}
