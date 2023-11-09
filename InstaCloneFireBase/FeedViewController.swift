//
//  FeedViewController.swift
//  InstaCloneFireBase
//
//  Created by Taha Özmen on 26.10.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var usercommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIDArray = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        getDataFromFirestore()
        
    }
    
    func getDataFromFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.usercommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.usercommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }
                
                
            }
        }
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = usercommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIDArray[indexPath.row]
        return cell
    }
    

   

}
