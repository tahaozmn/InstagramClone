//
//  UploadViewController.swift
//  InstaCloneFireBase
//
//  Created by Taha Özmen on 26.10.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var commentText: UITextField!
    
    
    @IBOutlet weak var uploadButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseimage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func chooseimage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "ERROR")
                } else {
                    
                    imageRef.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                          
                            // DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreRef : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email ?? "anonim", "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreRef = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                                    
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "selectt.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                            
            }
            
        }
        
    }
    

}

    }
        
    }
    }
