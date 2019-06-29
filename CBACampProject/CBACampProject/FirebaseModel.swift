//
//  FirebaseModel.swift
//  practice2
//
//  Created by 우아테크캠프_4 on 2018. 7. 28..
//  Copyright © 2018년 CBA. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseStorage

class FirebaseModel {
    static var messages = [Message]()
    static var imageNames : Array<String> = []
    static var sendMessageData = Message(text: "default", time: "default", auth: "default", isStaff : "default")
    static var schedule = "" 
    
    var ref: DatabaseReference!
    
    func getMessages() {
        print("trying to get messages....")
        
        ref = Database.database().reference().child("2019messages")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                FirebaseModel.messages = []
                for child in result {
                    let snapshotValue = child.value as! [String: AnyObject]
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    print(message)
                    let isStaff = snapshotValue["isStaff"] as? String ?? ""
                    print(message)
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff))
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got messages"), object: self)
            }
        })
    }
    
    func UpdateImageNames(title : String){
        FirebaseModel.imageNames.removeAll()
        
        ref = Database.database().reference().child("images").child(title)
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for i in result {
                    FirebaseModel.imageNames.append(i.value as! String)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change image"), object: self)
        })

    }
    
    func sendMessage(name: String, message: String) {
        let values = ["author":name, "message":message]
        
        self.ref.child("2019messages").setValue(values, withCompletionBlock: {(err, ref) in
            if(err == nil){
            }
        })
        
        //self.ref.child("2019messages").child("author").setValue(name)
        //self.ref.child("2019messages").child("message").setValue(message)
    }
    
    func downloadImage(name: String, imageView:UIImageView){
        Storage.storage().reference(withPath: name).downloadURL { (url, error) in
            imageView.kf.setImage(with: url)
        }
    }
    
    func getSchedule() {
        var ref: DatabaseReference!
        print("trying to get schedule...")
        Database.database().reference().child("images")
        
        ref = Database.database().reference().child("images").child("schedule")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? String ?? ""
            print(value)
            FirebaseModel.schedule = value
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got schedule"), object: self)
        })
    }
}
