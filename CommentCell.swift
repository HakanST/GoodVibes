//
//  CommentCell.swift
//  FIH
//
//  Created by Hakan Turgut on 2/23/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var postID = String()
    var commentID = String()
    var userID = String()
    var Likes = Int()
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButton(_ sender: UIButton) {
        
        let commentDB = Database.database().reference().child("Posts").child(postID).child("commentList")
        let userDB = Database.database().reference().child("Users")
        
        commentDB.child(commentID).child("likeList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //
            if snapshot.hasChildren() {
                
                let snapshotValue = snapshot.value as! Dictionary <String, Bool>
                
                //setValue(String((snapshotValue["likeList"] as! [String : Bool]).count))
                
                if snapshotValue[Auth.auth().currentUser!.uid] != nil {
                    print("1-")
                    commentDB.child(self.commentID).child("likeList").child(Auth.auth().currentUser!.uid).removeValue()
                    userDB.child(Auth.auth().currentUser!.uid).child("likedComments").child(self.commentID).removeValue()
                    //                postDB.child(self.postID).child("likes").setValue(snapshotValue.count)
                }
                    
                else {
                    print("2-")
                    commentDB.child(self.commentID).child("likeList").child(Auth.auth().currentUser!.uid).setValue(true)
                    userDB.child(Auth.auth().currentUser!.uid).child("likedComments").child(self.commentID).setValue(self.postID)
                    //                postDB.child(self.postID).child("likes").setValue(snapshotValue.count)
                }
                
            }
                
            else {
                print("3-")
                commentDB.child(self.commentID).child("likeList").child(Auth.auth().currentUser!.uid).setValue(true)
                userDB.child(Auth.auth().currentUser!.uid).child("likedComments").child(self.commentID).setValue(self.postID)
                //                postDB.child(self.postID).child("likes").setValue(1)
                
            }
            
        })
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
    
        let commentDB = Database.database().reference().child("Posts").child(postID).child("commentList")
        let userDB = Database.database().reference().child("Users")
        
        
       commentDB.child(commentID).child("likeList").observeSingleEvent(of: .value, with: { (snapshot) in
        
        //If comment has likes
        if snapshot.hasChildren(){
            
            let snapshotValue = snapshot.value as! Dictionary <String, Bool>
            
            //Iterate through all users that have liked this comment and remove the reference to the comment ID from the userDB
            for (key, value) in snapshotValue{
                
                userDB.child(key).child("likedComments").child(self.commentID).removeValue() //Remove comment ID reference from userDB
                
            }
            
            
        }
        
        })
        
        commentDB.child(commentID).removeValue()//Remove comment ID reference from original post in postDB (or commentDB)
        userDB.child(userID).child("commentedPosts").child(postID).child(commentID).removeValue() //Remove comment ID reference from userDB
        
        
        
    
    }
    
    
    
    
    
}
