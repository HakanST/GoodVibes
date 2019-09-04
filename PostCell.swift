//
//  PostCell.swift
//  FIH
//
//  Created by Hakan Turgut on 2/5/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    var postID = ""
    var userID = ""
    var likes = Int()
    
    var isMine =  false

    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
//    var delegate: CanReceive?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func likeButton(_ sender: UIButton) {
        let postDB = Database.database().reference().child("Posts")
        let userDB = Database.database().reference().child("Users")
        
        postDB.child(postID).child("likeList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //If post has any likes
            if snapshot.hasChildren() {
            
            let snapshotValue = snapshot.value as! Dictionary <String, Bool>
                
            //If user has already liked this post
            if snapshotValue[Auth.auth().currentUser!.uid] != nil {
                print("1-")
                postDB.child(self.postID).child("likeList").child(Auth.auth().currentUser!.uid).removeValue()
                userDB.child(Auth.auth().currentUser!.uid).child("likeList").child(self.postID).removeValue()
//                postDB.child(self.postID).child("likes").setValue(snapshotValue.count)
            }
            
            //If user hasn't yet liked this post
            else {
                print("2-")
                postDB.child(self.postID).child("likeList").child(Auth.auth().currentUser!.uid).setValue(true)
                userDB.child(Auth.auth().currentUser!.uid).child("likeList").child(self.postID).setValue(true)
//                postDB.child(self.postID).child("likes").setValue(snapshotValue.count)
            }
                
            }
            
            //If post doesn't have any likes, insert current user id in to likeList in the postDB. Also create a reference to the post in the likeList in the userDB
            else {
                print("3-")
                postDB.child(self.postID).child("likeList").child(Auth.auth().currentUser!.uid).setValue(true)
                userDB.child(Auth.auth().currentUser!.uid).child("likeList").child(self.postID).setValue(true)
//                postDB.child(self.postID).child("likes").setValue(1)
                
            }
            
        })
        
    }
    

    @IBAction func deleteButton(_ sender: UIButton) {
   
        let postDB = Database.database().reference().child("Posts")
        let userDB = Database.database().reference().child("Users")
        
        
         postDB.child(postID).child("likeList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //If Post has likes
            if snapshot.hasChildren(){
            
            let snapshotValue = snapshot.value as! Dictionary <String, Bool>
            
            //Remove all references to the users that liked this post
            for (key, value) in snapshotValue{

                userDB.child(key).child("likeList").child(self.postID).removeValue()

            }
            
//            Originally did this, still works (Alternate way to iterate)
//
//                        let array = Array(snapshotValue)
//
//                        for i in 0..<array.count{
//
//                            userDB.child(array[i].key).child("likeList").child(self.postID).removeValue()
//
//                        }
                
            }
            
         })
        
        //Remove all references to the users that commented to this post
        postDB.child(postID).child("commentList").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChildren(){
            
                let snapshotValue = snapshot.value as! Dictionary <String, Dictionary <String, Any>>
                
                //Iterates through each comment node for the post in the postDB.
                for (key1, value1) in snapshotValue{
                    
                    let commentUID = value1["userID"] as! String
                    userDB.child(commentUID).child("commentedPosts").child(self.postID).removeValue() //Removes reference to comments of deleted post from user DB
                    
                    if value1["likeList"] != nil{
                    
                        let likeList = value1["likeList"] as! Dictionary <String, Bool>
                    
                        for (key2, value2) in likeList{
                        
                            userDB.child(key2).child("likedComments").child(key1).removeValue() //Removes reference to liked comments of deleted post from user DB
                        }
                        
                    }

                }
                
            }

        })
        
        postDB.child(postID).removeValue() //Removes post from post DB
        
        userDB.child(userID).child("userPosts").child(postID).removeValue() //Removes post reference in userDB
        
    }
    
}
