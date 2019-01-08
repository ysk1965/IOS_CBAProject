//
//  SendMessageViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 9..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import Firebase

class SendMessageViewController: UIViewController {
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
        
        dbRef = Database.database().reference()

        SendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
