//
//  AuthViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2018. 11. 13..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class AuthViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func LoginAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){
            (user, error) in
            
            if (error != nil){
                Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!){
                    (user, error) in
                }
            } else{
                let alert = UIAlertController(title: "알림", message: "회원가입완료", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:
                    "확인", style:UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        Auth.auth().addStateDidChangeListener({(user, err) in
            if user != nil{
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
