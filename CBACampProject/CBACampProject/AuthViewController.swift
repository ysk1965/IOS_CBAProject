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

class AuthViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var CancleLabel: UIButton!
    @IBOutlet weak var LoginLabel: UIButton!
    @IBAction func UnwindAction(segue: UIStoryboard){
        
    }
    @IBAction func CancleAction(_ sender: Any) {
        CancleLabel.popIn()
        dismiss(animated: true)
    }
    
    /*
    @IBAction func CreateID(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!)
        {
            (user, error) in
            
            // error : ID가 있거나 비밀번호가 6자리 이하이거나
            if (error != nil){
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!){
                    (user, error) in
                    
                    if(error != nil){
                        let alert = UIAlertController(title: "회원가입 실패", message: "회원가입에 실패하셨습니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title:
                            "확인", style:UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else{
                        let alert = UIAlertController(title: "회원가입 성공", message: "회원가입에 성공하셨습니다." + "\n UserID : " + (user?.user.email)!, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title:
                            "확인", style:UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    */
    
    @IBAction func LoginAction(_ sender: Any) {
        LoginLabel.popIn()
        // Email을 쓰는 곳
        Auth.auth().createUser(withEmail: email.text!, password: password.text!)
        {
            (user, error) in
            
            // error : ID가 있거나 비밀번호가 6자리 이하이거나
            if (error != nil){
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!){
                    (user, error) in
                    //...
                    if(error != nil){
                        let alert = UIAlertController(title: "로그인 실패", message: "로그인에 실패하셨습니다. \n 다시 로그인해주세요", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title:
                            "확인", style:UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    } else{
                        let alert = UIAlertController(title: "로그인 성공", message:"["+(user?.user.email)! + "] \n 로그인에 성공하셨습니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title:
                            "확인", style:UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // User가 존재한다.
        // addStateDidChangeListener
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        Auth.auth().addStateDidChangeListener({(user, err) in
            if user.currentUser != nil{
                // Login상태라면 뒤로 돌아가
                self.dismiss(animated: true)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -130 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
