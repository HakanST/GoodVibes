//
//  Post.swift
//  FIH
//
//  Created by Hakan Turgut on 2/2/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    var ID = String()
    var userID = String()
    var userName = String()
    
    var postType = Int()
    var Body = String()
    var Likes = Int() //
    var timeStamp = String()
    var Anonymous: Bool = false
    var Replies = String() //Static
    var imageURL : String?
    
}


