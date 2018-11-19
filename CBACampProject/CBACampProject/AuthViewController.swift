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
    
    @IBAction func UnwindAction(segue: UIStoryboard){
        
    }
    
    @IBAction func CreateID(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!)
        {
            (user, error) in
            
            // error : ID가 있거나 비밀번호가 6자리 이하이거나
            if (error != nil){
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!){
                    (user, error) in
                    //...
                    let alert = UIAlertController(title: "알림", message: "로그인", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:
                        "확인", style:UIAlertActionStyle.default, handler: nil))
                }
            }
            else{
                let alert = UIAlertController(title: "알림", message: "회원가입완료", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:
                    "확인", style:UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        // Email을 쓰는 곳
        Auth.auth().createUser(withEmail: email.text!, password: password.text!)
        {
            (user, error) in
            
            // error : ID가 있거나 비밀번호가 6자리 이하이거나
            if (error != nil){
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!){
                    (user, error) in
                    //...
                    let alert = UIAlertController(title: "알림", message: "로그인", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:
                        "확인", style:UIAlertActionStyle.default, handler: nil))
                }
            }
            else{
                // 로그인에 실패하셨습니다.
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User가 존재한다.
        // addStateDidChangeListener
        Auth.auth().addStateDidChangeListener({(user, err) in
            if user.currentUser != nil{
                // Login상태라면 뒤로 돌아가
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
