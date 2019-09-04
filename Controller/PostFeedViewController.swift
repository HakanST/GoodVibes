//
//  PostFeedViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 2/2/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit

class PostFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var postArray : [Post] = [Post]()
    
    @IBOutlet weak var postFeedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postFeedTable.delegate = self
        postFeedTable.dataSource = self
        
        postFeedTable.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")

        configureTableView()
        retreivePosts()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell

        cell.postBodyLabel!.text = postArray[postArray.count - 1 - indexPath.row].Body
        
        cell.userNameLabel!.text = postArray[postArray.count - 1 - indexPath.row].userName
        
        cell.dateTimeLabel!.text = postArray[postArray.count - 1 - indexPath.row].timeStamp
        
        cell.likeLabel!.text = String(postArray[postArray.count - 1 - indexPath.row].Likes)
        
        cell.postID = postArray[postArray.count - 1 - indexPath.row].ID
        cell.userID = postArray[postArray.count - 1 - indexPath.row].userID
        cell.likes = postArray[postArray.count - 1 - indexPath.row].Likes
        
        if Auth.auth().currentUser!.uid == cell.userID{
            cell.isMine = true
        }
        
        
        if let url = postArray[postArray.count - 1 - indexPath.row].imageURL{

//            let url = postArray[postArray.count - 1 - indexPath.row].imageURL

            let photoDB = Storage.storage().reference(forURL: url)

            // Create a reference to the file you want to download


            photoDB.getData(maxSize: 2*1024*1024, completion:
                { (data, error) in
                    if error != nil{
                    print(error!)
                    }

                    else {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            cell.postImage.image = image
                        }
                    }

            })

        }
        
//            // Create local filesystem URL
//            let localURL = URL(string: "path/to/image")!
//
            // Download to the local filesystem
//            let downloadTask = islandRef.write(toFile: localURL) { url, error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
//                } else {
//                    // Local file URL for "images/island.jpg" is returned
//                }
//            }
            
            
            
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }

    func retreivePosts(){

        let postDB = Database.database().reference().child("Posts")

        postDB.observe(.childAdded) { (snapshot) in

            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            let postID = snapshotValue["postID"]!
            let userID = snapshotValue["userID"]!
            let userName = snapshotValue["userName"]!
            let postBody = snapshotValue["postBody"]!
            let timeStamp = snapshotValue["timeStamp"]!
          
            let post = Post()
            
            post.ID = postID as! String
            post.userID = userID as! String
            post.userName = userName as! String
            post.Body = postBody as! String
            post.timeStamp = timeStamp as! String
            
            if (snapshotValue["imageURL"] != nil){
                post.imageURL = snapshotValue["imageURL"] as! String
                
            }
            
            if (snapshotValue["likeList"] != nil ){
                post.Likes = (snapshotValue["likeList"] as! Dictionary<String,Int>).count
            
            }
            
            else { post.Likes = 0}
            self.postArray.append(post)

            self.postFeedTable.reloadData()
            
        }
        
        postDB.observe(.childRemoved) { (snapshot) in
            
            print("1*****")
    
            for i in 0..<self.postArray.count{
                
                if self.postArray[i].ID == String(snapshot.key){
                    self.postArray.remove(at: i)
                    break

                }
                
            }
            
            self.postFeedTable.reloadData()
            
    }
        
        postDB.observe(.childChanged) { (snapshot) in
            
             print("2*****")
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            if (snapshotValue["likeList"] != nil) {
            
            for i in 0..<self.postArray.count{
                
                if self.postArray[i].ID == String(snapshot.key){
                    self.postArray[i].Likes = (snapshotValue["likeList"]! as AnyObject).count
                    break
                }
                
            }
                
            }
            
            else {
                
                for i in 0..<self.postArray.count{
                    
                    if self.postArray[i].ID == String(snapshot.key){
                        self.postArray[i].Likes = 0
                        break
                    }
                    
                }
                
            }

            self.postFeedTable.reloadData()
            
        }
        
        
    }
    
    func configureTableView(){
        postFeedTable.rowHeight = 200
       postFeedTable.estimatedRowHeight = 200
    }
    
//    Comment Segue Option 1

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoComments", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoComments"{
            
            let destinationVC = segue.destination as! CommentFeedViewController

//            destinationVC.data = field1.text!
            if let indexPath = postFeedTable.indexPathForSelectedRow {
                destinationVC.selectedPost = postArray[postArray.count - 1 - indexPath.row].ID

            }

        }
    }


}



