//
//  SendMessageViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 9..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class SendMessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var dbRef : DatabaseReference!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet var mainView: UIScrollView!
    @IBOutlet weak var textAuthor: UITextField!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var sungrakCI: UIImageView!
    var currentTime: String?
    
    @IBAction func CancleButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let date = Date()
    let calendar = Calendar.current
    var isStaff = false
    
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
        
        if((Auth.auth().currentUser) != nil){
            // 공지보내는 사람 핸드폰
            if(CBAInfoTabViewController.isSendNotiMessage == true){ // 조건 만들자
                if(textAuthor.text == ""){
                    dbRef.child(
                    AgencySingleton.shared.AgencyTitle! + "/noti").childByAutoId().setValue([
                        "author" : "CBA 본부",
                        "message" : textMessage.text!,
                        "isStaff" : "공지",
                        "time" : currentTime,
                        "uid" : AgencySingleton.shared.realmUid!
                    ])
                } else{
                    dbRef.child(
                    AgencySingleton.shared.AgencyTitle! + "/noti").childByAutoId().setValue([
                        "author" : textAuthor.text!,
                        "message" : textMessage.text!,
                        "isStaff" : "공지",
                        "time" : currentTime,
                        "uid" : AgencySingleton.shared.realmUid!
                    ])
                }
                CBAInfoTabViewController.isSendNotiMessage = false
            } else{
                dbRef.child(
                AgencySingleton.shared.AgencyTitle! + "/message").childByAutoId().setValue([
                    "author" : textAuthor.text!,
                    "message" : textMessage.text!,
                    "isStaff" : CBAInfoTabViewController.mainUser.grade,
                    "time" : currentTime,
                    "uid" : AgencySingleton.shared.realmUid!
                ])
            }
        } else{
            dbRef.child(AgencySingleton.shared.AgencyTitle! + "/message").childByAutoId().setValue([
                "author" : textAuthor.text!,
                "message" : textMessage.text!,
                "isStaff" : "non-staff",
                "time" : currentTime,
                "uid" : AgencySingleton.shared.realmUid!
                ])
            

            //let sender = FirebaseModel.PushNotificationSender()
            
            //sender.sendPushNotification(to: "cba_admin", title: "title", body: "body")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AgencySingleton.shared.AgencyTitle != "2019_SR_SUMMER"){
            sungrakCI.alpha = 0
        } else {
            sungrakCI.alpha = 1
        }
        
        backgroundView.image = UIImage(named: AgencySingleton.shared.backgroundImageName!)
        
        textMessage.returnKeyType = .done
        
        textMessage.text = "  하고 싶은 말을 남겨주세요"
        textMessage.textColor = UIColor.lightGray
        textMessage.font = UIFont(name: "NotoSansUI-Regular", size: 13.0)
        textMessage.returnKeyType = .done
        
        textMessage.delegate = self
        
        dbRef = Database.database().reference()

        SendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        SendButton.popIn()
        
        //textAuthor.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        self.view.frame.origin.y = -100 // Move view 150 points upward
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
            textView.font = UIFont(name: "NotoSansUI-Regular", size: 18.0)
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
            textView.font = UIFont(name: "NotoSansUI-Regular", size: 13.0)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
    
    /*
    func textFCM(){
        //변환해줘야 해
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list/new"
            let date : String = "2019-05-05" // 현재 날짜
            let campusName : String = selectedCampus!
            
            let params : Parameters = [
                "date" : date,
                "campus" : campusName
            ]
            
            let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header)
            
            alamo.responseJSON { response in
                let json = JSON(response.result.value!)
                let results = json["data"].arrayValue
                if let status = response.response?.statusCode{
                    switch(status){
                    case 200..<300:
                        print("success")
                        print("JSON: \(json)")
                        
                        for result in results {
                            var test = AttendanceInfo.init()
                            
                            /*
                             let id = result["id"].stringValue
                             let date = result["date"].stringValue
                             let name = result["name"].stringValue
                             let mobile = result["mobile"].stringValue
                             let status = result["status"].stringValue
                             let note = result["note"].stringValue
                             */
                            
                            test.id = result["id"].stringValue
                            test.date = result["date"].stringValue
                            test.name = result["name"].stringValue
                            test.mobile = result["mobile"].stringValue
                            test.status = result["status"].stringValue
                            test.note = result["note"].stringValue
                            
                            self.currentAttendanceInfo.append(test)
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                    default:
                        print("error with response status: \(status)")
                    }
                }
            }
        }
    }
    */
}
