//
//  SendMessageViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 9..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import Firebase

class SendMessageViewController: UIViewController, UITextViewDelegate {
    var dbRef : DatabaseReference!
    
    @IBOutlet weak var textAuthor: UITextField!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var SendButton: UIButton!
    @IBAction func CancleButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMessage(){
        dbRef.child("2019messages").childByAutoId().setValue(["author" : textAuthor.text!, "message" : textMessage.text!])
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textMessage.text = "하고 싶은 말을 남겨주세요"
        textMessage.textColor = UIColor.lightGray
        textMessage.font = UIFont(name: "verdana", size: 13.0)
        textMessage.returnKeyType = .done
        textMessage.delegate = self
        
        dbRef = Database.database().reference()

        SendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "하고 싶은 말을 남겨주세요" {
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
            textView.text = "하고 싶은 말을 남겨주세요"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
