//
//  ReplyFeedViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 2/20/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class CommentFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var selectedPost : String?
    
    var commentArray : [Comment] = [Comment]()
    
    @IBOutlet weak var commentTable: UITableView!
    
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(selectedPost)
        commentTable.delegate = self
        commentTable.dataSource = self
        
        commentTable.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        configureTableView()
        retreivePosts()
        
        commentTable.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.commentBodyLabel!.text = commentArray[indexPath.row].Body
        
        cell.userNameLabel!.text = commentArray[indexPath.row].userName
        
        cell.timeStampLabel!.text = commentArray[indexPath.row].timeStamp
        
        cell.likesLabel!.text = String(commentArray[indexPath.row].Likes)
        
        cell.postID = selectedPost!
        cell.commentID = commentArray[indexPath.row].ID
        cell.userID = commentArray[indexPath.row].userID
        cell.Likes = commentArray[indexPath.row].Likes
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func retreivePosts(){
        
        let commentDB = Database.database().reference().child("Posts").child(selectedPost!).child("commentList")
        
       commentDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            let commentID = snapshot.key
            let userID = snapshotValue["userID"]!
            let userName = snapshotValue["userName"]!
            let commentBody = snapshotValue["commentBody"]!
            let timeStamp = snapshotValue["timeStamp"]!
            
            let comment = Comment()
            
            comment.ID = commentID as! String
            comment.userID = userID as! String
            comment.userName = userName as! String
            comment.Body = commentBody as! String
            comment.timeStamp = timeStamp as! String
            
            if (snapshotValue["likeList"] != nil ){
                comment.Likes = (snapshotValue["likeList"] as! Dictionary<String,Int>).count
                
            }
                
            else { comment.Likes = 0}
            self.commentArray.append(comment)
        
        
            self.commentTable.reloadData()
            
        }
        
        commentDB.observe(.childRemoved) { (snapshot) in
            
            print("1*****1")
            
            for i in 0..<self.commentArray.count{
                
                if self.commentArray[i].ID == String(snapshot.key){
                    self.commentArray.remove(at: i)
                    break
                    
                }
                
            }
            
            self.commentTable.reloadData()
            
        }
        
        commentDB.observe(.childChanged) { (snapshot) in
            
            print("2*****2")
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            if (snapshotValue["likeList"] != nil) {
                
                for i in 0..<self.commentArray.count{
                    
                    if self.commentArray[i].ID == String(snapshot.key){
                        self.commentArray[i].Likes = (snapshotValue["likeList"]! as AnyObject).count
                        break
                    }
                    
                }
                
            }
                
            else {
                
                for i in 0..<self.commentArray.count{
                    
                    if self.commentArray[i].ID == String(snapshot.key){
                        self.commentArray[i].Likes = 0
                        break
                    }
                    
                }
                
            }
            
            self.commentTable.reloadData()
            
        }
        
    }
    
    func configureTableView(){
        commentTable.rowHeight = 200
        commentTable.estimatedRowHeight = 200
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        let postDB = Database.database().reference().child("Posts")
        let userDB = Database.database().reference().child("Users")
        
        let userID = Auth.auth().currentUser!.uid
        let commentID: String = postDB.childByAutoId().key!
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        //        formatter.dateFormat = "YYYY.MM.dd - HH:mm"
        let timeStamp = formatter.string(from: date)
        
        let likeListDictionary: [String: Bool] = [:]
        
        let commentDictionary = ["userID" : userID, "userName": Auth.auth().currentUser?.email, "commentBody": commentField.text!, "timeStamp" : timeStamp, "likeList" : likeListDictionary] as [String : Any]
        
        postDB.child(selectedPost!).child("commentList").child(commentID).setValue(commentDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
                
            else {
                print("Comment successfully saved")
                userDB.child(userID).child("commentedPosts").child(self.selectedPost!).child(commentID).setValue(true)
            }
            
        }
    }
    

}

