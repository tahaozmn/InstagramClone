//
//  ViewController.swift
//  InstaCloneFireBase
//
//  Created by Taha Özmen on 25.10.2023.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var pwText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && pwText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: pwText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "ERROR", messageInput: "Username/Password ?")
        }
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && pwText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: pwText.text!) { (authdata, error) in
                
                if error != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                    
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
        } else {
          makeAlert(titleInput: "ERROR", messageInput: "Username/Password ?")
        }
        
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
}

