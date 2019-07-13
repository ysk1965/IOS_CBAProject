//
//  SendMessageViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 9..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import Firebase

class SendMessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var dbRef : DatabaseReference!
    
    @IBOutlet var mainView: UIScrollView!
    @IBOutlet weak var textAuthor: UITextField!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var SendButton: UIButton!
    var currentTime: String?
    
    @IBAction func CancleButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let date = Date()
    let calendar = Calendar.current
    
    @objc func sendMessage(){
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        if(hour > 12){
            currentTime = "\(month)월\(day)일 오후\(hour-12):\(minute)"
        } else{
            currentTime = "\(month)월\(day)일 오전\(hour):\(minute)"
        }
        if((Auth.auth().currentUser) != nil){ dbRef.child(AgencySingleton.shared.AgencyTitle! + "/noti").childByAutoId().setValue(["author" : textAuthor.text!, "message" : textMessage.text!, "isStaff" : MassageTabViewController.mainUser.gbsLevel, "time" : currentTime, "uid" : AgencySingleton.shared.realmUid!])
        } else{
            dbRef.child(AgencySingleton.shared.AgencyTitle! + "/noti").childByAutoId().setValue(["author" : textAuthor.text!, "message" : textMessage.text!, "isStaff" : "non-staff", "time" : currentTime, "uid" : AgencySingleton.shared.realmUid!])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textMessage.returnKeyType = .done
        
        textMessage.text = "  하고 싶은 말을 남겨주세요"
        textMessage.textColor = UIColor.lightGray
        textMessage.font = UIFont(name: "verdana", size: 13.0)
        textMessage.returnKeyType = .done
        
        textMessage.delegate = self
        
        dbRef = Database.database().reference()

        SendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        //textAuthor.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "  하고 싶은 말을 남겨주세요" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "  하고 싶은 말을 남겨주세요"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
}
