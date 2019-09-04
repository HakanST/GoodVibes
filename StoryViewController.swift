//
//  CreateStoryViewController.swift
//  FIH
//
//  Created by Hakan Turgut on 1/31/19.
//  Copyright © 2019 T&C. All rights reserved.
//

import UIKit
import Firebase
import Photos


class StoryViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var postArray : [Post] = [Post]()
    
    @IBOutlet weak var storyField: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    var uploadImage: UIImage!
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            PHPhotoLibrary.requestAuthorization { (Status) in
                switch Status {
                    
                case .authorized :
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true)
                    
                case .notDetermined :
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true)
                    
                case .restricted :
                    let alert = UIAlertController(title: "Photo Library Restricted", message: "The photo library is restricted and cannot be accessed", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okButton)
                    self.present(alert, animated: true)
                    
                case .denied :
                    
                    let alert = UIAlertController(title: "Denied", message: "Photo library was previously denied. Please update your settings if you wish to change it.", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "Go to settings", style: .default) { (action) in
                        DispatchQueue.main.async {
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url,options: [:])
                        }
                    }
                    alert.addAction(cancelButton)
                    self.present(alert, animated: true)
                    
                }
            }
        }
        
    }
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let postDB = Database.database().reference().child("Posts")
        let userDB = Database.database().reference().child("Users")
        let photoDB = Storage.storage().reference()
        
        let userID = Auth.auth().currentUser!.uid
        let postID: String = postDB.childByAutoId().key!
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
//        formatter.dateFormat = "YYYY.MM.dd - HH:mm"
        let timeStamp = formatter.string(from: date)
        
        if let imageData = uploadImage?.pngData(){
            
            photoDB.child("PostImage").child(postID + ".png").putData(imageData, metadata: nil, completion:
                {(metadata,error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                        
                    else {
                        print(metadata!)
                        //                        self.imageURL = postID + ".png"
                        photoDB.child("PostImage").child(postID + ".png").downloadURL { (url, error) in
                            if (error != nil){
                                print(error!)
                            }
                                
                            else {
                                    self.imageURL = url?.absoluteString
                                    print(url)
                            }
                        }
                    }
            })
            
        }
        
        
        let likeListDictionary: [String: Bool] = [:]
        
        let postDictionary = ["postID" : postID, "userID" : userID, "userName": Auth.auth().currentUser?.email, "postBody": storyField.text!, "timeStamp" : timeStamp, "likeList" : likeListDictionary, "imageURL" : imageURL] as [String : Any]
        
        postDB.child(postID).setValue(postDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            
            else {
                print("Post successfully saved")
                userDB.child(userID).child("userPosts").child(postID).setValue(true)
            }
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            postImage.image = image
            uploadImage = image
            dismiss(animated: true, completion: nil)
        }
        
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            postImage.image = image
            uploadImage = image
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}


