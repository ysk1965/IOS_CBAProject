//
//  AttendanceViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 5. 13..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import SwiftyJSON

struct AttendanceInfo: Codable {
    var id : String?
    var date : String?
    var name : String?
    var mobile : String?
    var status : String?
    var note : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        note = try values.decodeIfPresent(String.self, forKey: .note)
    }
    
    init() {
        id = " "
        date = " "
        name = " "
        mobile = " "
        status = " "
        note = " "
    }
}

struct checkAPI {
    var id : String?
    var date : String?
    var name : String?
    var mobile : String?
    var status : String?
    var note : String?
}

class AttendanceViewController: UIViewController {
    @IBOutlet weak var statsText: UILabel!
    @IBOutlet weak var campusName: UILabel!
    @IBOutlet weak var attendanceScrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedCampus : String?
    var currentAttendanceInfo : Array<AttendanceInfo> = []
    var buttonArray : Array<UIButton> = []
    var textArray : Array<UITextView> = []
    
    var errorCode = 999 // attend value error
    var isEmptyFlag : Bool = false
    
    var currentDate : String?
    
    @IBAction func ConfirmButton(_ sender: Any) {
        //confirm을 누를 때 세부사항 text저장 후 아래서 보내 줌
        //status는 누를 때마다 상태가 변경되기에 여기서 저장 안해도 됨 (renewAttend)
        for n in 0...currentAttendanceInfo.count - 1{
            currentAttendanceInfo[n].note = textArray[n].text
        }
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list/report"
            let date : String = "2019-05-05" // [NEEDED] DatePicker의 날자로 적용되어야 함
            let campusName : String = selectedCampus!
                
            let params : Parameters = [
                "checkList" : currentAttendanceInfo, // [NEEDED] 요게 제대로 작동하는지 확인해야 함
                "leaderUid" : "9999" // [NEEDED] leader의 uid로 차후에 수정해야 함
            ]
            
            let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            
            alamo.responseJSON { response in
                print(response)
            }
            
            // [NEEDED]변경이 완료되었습니다! 같은 Alert가 필요할듯
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        // 출석부 생성해서 받아와야 해
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
    
    @IBAction func prevButton(_ sender: Any) {
        LoadAttendanceList(nav: "PREV")
    }
    
    @IBAction func nextButton(_ sender: Any) {
        LoadAttendanceList(nav: "NEXT")
    }
    
    func setStats(){
        var attendCnt = 0
        var allCnt = -1
        var attendPercent = 0
        
        allCnt = currentAttendanceInfo.count
        
        if(allCnt == 0){
            statsText.text = "데이터가 없습니다."
            return
        }
        
        for n in 0...currentAttendanceInfo.count - 1{
            if(currentAttendanceInfo[n].status == "ATTENDED"){
                attendCnt += 1
            }
        }
        
        attendPercent = attendCnt / allCnt * 100
        statsText.text = "출석 \(attendCnt) / 전체 \(allCnt) / \(attendPercent) %"
    }
    
    // nav : PREV, CURRENT, NEXT
    func LoadAttendanceList(nav : String){
        // 서버에 지금 캠퍼스와 날짜를 보내줘야 함
        // 그러면 날짜 목록을 서버가 보내 줌
        //Alamofire
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list"
            let date : String = "2019-05-05" // [NEEDED] DatePicker의 날자로 변경되어야 함
            let campusName : String = selectedCampus!
            let navpoint : String = nav
            
            let params : Parameters = [
                "date" : date,
                "campus" : campusName,
                "nav" : navpoint
            ]
            
            let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header)
            
            alamo.responseJSON { response in
                let json = JSON(response.result.value!)
                let results = json["data"].arrayValue
                if let status = response.response?.statusCode{
                    switch(status){
                    case 200..<300:
                        print("success")
                        print("JSON: \(json)")
                        self.currentAttendanceInfo.removeAll()

                        for result in results {
                            var test = AttendanceInfo.init()
                            
                            test.id = result["id"].stringValue
                            test.date = result["date"].stringValue
                            test.name = result["name"].stringValue
                            test.mobile = result["mobile"].stringValue
                            test.status = result["status"].stringValue
                            test.note = result["note"].stringValue
                            
                            self.currentAttendanceInfo.append(test)
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                        break
                    case 403:
                        // Empty
                        self.isEmptyFlag = true
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                        break
                    default:
                        print("error with response status: \(status)")
                    }
                }
            }
        }
    }
    
    @objc func viewload(_ notification: Notification) {
        attendanceScrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: attendanceScrollView.frame)
        attendanceScrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        if (self.isEmptyFlag == true){
            // [NEEDED] editButton 코드로 생성해 주세요..!
            
            self.isEmptyFlag = false
            return
        }
        
        
        var inypos = 1
        let inxpos = 20
        let count = currentAttendanceInfo.count
        
        for i in 0..<count {
            var nextypos = 0
            let cellview = UIView()
            cellview.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5).cgColor
            cellview.layer.borderWidth = 0
            
            
            cellview.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(attendanceScrollView.frame.width), height: 80)
            attendanceScrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = currentAttendanceInfo[i].name!
            namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            namelabel.textColor = UIColor.black
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 20, y: 18)
            cellview.addSubview(namelabel)
            
            ///agelabel
            let mobilelabel = UILabel()
            mobilelabel.text = currentAttendanceInfo[i].mobile!
            mobilelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            mobilelabel.textColor = UIColor.black
            mobilelabel.sizeToFit()
            mobilelabel.frame.origin = CGPoint(x: 90, y: 18)
            cellview.addSubview(mobilelabel)
            
            buttonArray.append(UIButton.init())
            buttonArray[i].setTitle(String(i), for: .normal)
            if(currentAttendanceInfo[i].status == "ATTENDED"){
                buttonArray[i].setTitleColor(UIColor.black, for: .normal)
                buttonArray[i].backgroundColor = UIColor.black
            } else{
                buttonArray[i].setTitleColor(UIColor.blue, for: .normal)
                buttonArray[i].backgroundColor = UIColor.blue
            }
            buttonArray[i].frame = CGRect(x: 220, y: 18 , width: 25, height: 25)
            buttonArray[i].addTarget(self, action: #selector(self.Attend(_:)), for: .touchUpInside)
            
            //textview///////////////////////////////////////
            textArray.append(UITextView.init())
            textArray[i].frame.origin = CGPoint(x:250, y:18)
            textArray[i].frame.size = CGSize(width: 100, height: 25)
            textArray[i].backgroundColor = UIColor.white
            textArray[i].text = currentAttendanceInfo[i].note
            cellview.addSubview(textArray[i])
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(attendanceScrollView.frame.width) - inxpos * 2, height: 120)
            let contentSize = textview.sizeThatFits(textview.bounds.size)
            var frame = textview.frame
            frame.size.height = max(contentSize.height, 12)
            textview.frame = frame
            textview.isScrollEnabled = false
            textview.isEditable = false
            textview.isUserInteractionEnabled = true
            nextypos = Int(textview.frame.origin.y + textview.frame.size.height + 8)
            textview.backgroundColor = UIColor.init(white: 0, alpha: 0)
            
            cellview.frame.size.height = CGFloat(nextypos)
            inypos += Int(cellview.frame.size.height) //다음 CellView의 위치
            cellview.addSubview(buttonArray[i])
            cellview.addSubview(textview)
        }
        attendanceScrollView.contentSize = CGSize(width: attendanceScrollView.frame.width-1, height: max(CGFloat(inypos),attendanceScrollView.frame.height+1))
        attendanceScrollView.isScrollEnabled = true
        
        setStats() // Title 표시
        self.view.addSubview(attendanceScrollView)
    }
    
    // gray : NOT CHECKED
    // blue : ATTENDED
    // black : ABSENT
    @objc func Attend(_ sender:UIButton){
        if(sender.backgroundColor == UIColor.black){
            sender.backgroundColor = UIColor.blue
            renewAttend(idx: Int(sender.currentTitle!) ?? errorCode, check: "ABSENT")
        } else if (sender.backgroundColor == UIColor.gray){
            sender.backgroundColor = UIColor.blue
            renewAttend(idx: Int(sender.currentTitle!) ?? errorCode, check: "NOT_CHECKED")
        } else{
            sender.backgroundColor = UIColor.black
            renewAttend(idx: Int(sender.currentTitle!) ?? errorCode, check: "ATTENDED")
        }
    }
    
    func renewAttend(idx : Int, check : String){
        currentAttendanceInfo[idx].status = String(check)
    }
    
    func saveCurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = dateFormatter.string(from: date) // --- 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveCurrentDate() // [NEEDED] DatePicker로 계속 변경되어야 하고 처음에는 오늘날자로 적용 되도록
        campusName.text = selectedCampus
        
        LoadAttendanceList(nav: "CURRENT")
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "update AttendanceBook"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self) // 초기화면 로드 (당일이 나와야 함)
    }
}
