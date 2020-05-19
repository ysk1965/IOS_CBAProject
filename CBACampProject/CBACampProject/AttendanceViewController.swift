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
import MBRadioCheckboxButton

struct AttendanceInfo: Codable {
    var id : String?
    var date : String?
    var name : String?
    var mobile : String?
    var status : String?
    var note : String?
    var hidden : Bool?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        hidden = try values.decodeIfPresent(Bool.self, forKey: .hidden)
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

struct ReportAttendancePost: Encodable {
    var checkList : Array<AttendanceData>
    var leaderUid : String
}

struct AttendanceData: Encodable {
    var id : Int
    var status : String
    var note : String
}

struct ReportEditPost: Encodable {
    var editActions : Array<EditData>
    var leaderUid : String
}

struct EditData: Encodable {
    var id : Int
    var action : String
}

class AttendanceViewController: UIViewController {
    @IBOutlet weak var statsText: UILabel!
    @IBOutlet weak var campusName: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var makeAttendanceButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func DeleteAlertAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "출석부 삭제", message: "OK버튼을 누르면 현재 날짜의 출석부가 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: DeleteAttandenceAction(_:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DeleteAttandenceAction(_ sender: Any) {
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list"
            let date : String = SettingDate() // [NEEDED] DatePicker의 날자로 변경되어야 함
            let campusName : String = selectedCampus!
            
            let params : Parameters = [
                "date" : date,
                "campus" : campusName,
                "leaderUid" : Auth.auth().currentUser!.uid
            ]
            
            let header: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
            ]
            
            let alamo = AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: header)
            
            alamo.responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.LoadAttendanceList(nav: "CURRENT")
                    print(value)
                case .failure(let error):
                    self.LoadAttendanceList(nav: "CURRENT")
                    print(error)
                }
            }
        }
    }
    
    @objc func MakeAttendance(_ sender:UIButton){
        // 출석부 생성해서 받아와야 해
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list/new"
            let date : String = SettingDate() // 현재 날짜
            let campusName : String = selectedCampus!
            
            
            let params : Parameters = [
                "date" : date,
                "campus" : campusName
            ]
            
            let header: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
            ]
            let alamo = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            
            print(params)
            
            alamo.responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("success MAKE")
                    print("JSON: \(json)")
                    let results = json["data"].arrayValue
                    
                    self.dailyAllAttendanceInfo.removeAll()
                    
                    for result in results {
                        var test = AttendanceInfo.init()
                        
                        test.id = result["id"].stringValue
                        test.date = result["date"].stringValue
                        test.name = result["name"].stringValue
                        test.mobile = result["mobile"].stringValue
                        test.status = result["status"].stringValue
                        test.note = result["note"].stringValue
                        
                        self.dailyAllAttendanceInfo[String(test.id!)] = test
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    var selectedCampus : String?
    var dailyAllAttendanceInfo : Dictionary<String, AttendanceInfo> = [:]
    var attendRadioButtonArray : Array<RadioButton> = []
    var deleteRadioButtonArray : Array<RadioButton> = []
    var hiddenRadioButtonArray : Array<RadioButton> = []
    var editDictionary : Dictionary<String, EditData> = [:]
    var attendTextDictionary : Dictionary<String, UITextView> = [:]
    
    var errorCode = 999 // attend value error
    var isEmptyFlag : Bool = false
    
    var currentDate : String?
    
    func SettingDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.string(from: datePicker.date)
        
        return formatter.string(from: datePicker.date)
    }
    
    func SettingString2Date(a : String) -> Date {
        let dateString = a
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name : "UTC") as TimeZone?
        
        let date:Date = dateFormatter.date(from : dateString)!
        
        return date
    }
    
    @IBAction func DateValueChange(_ sender: Any) {
        LoadAttendanceList(nav: "CURRENT")
    }
    
    struct ParameterQueryEncoding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try urlRequest.asURLRequest()
            request.httpBody = parameters?
                .map { "\($0)=\($1)" }
                .joined(separator: "&")
                .data(using: .utf8)
            return request
        }
    }
    
    @IBAction func ConfirmButton(_ sender: Any) {
        //confirm을 누를 때 세부사항 text저장 후 아래서 보내 줌
        //status는 누를 때마다 상태가 변경되기에 여기서 저장 안해도 됨 (renewAttend)
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list/report"
            
            let date : String = SettingDate() // [NEEDED] DatePicker의 날자로 적용되어야 함
            let campusName : String = selectedCampus!
            
            var paramList = SettingSendAttandanceList()
            
            var params = ReportAttendancePost(checkList: paramList, leaderUid: Auth.auth().currentUser!.uid)
            
            let header: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
            ]

            let alamo = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: header).response { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    self.LoadAttendanceList(nav: "CURRENT")
                case .failure(let error):
                    print(error)
                    self.LoadAttendanceList(nav: "CURRENT")
                }
            }
            // TODO : 변경이 완료되었습니다! 같은 Alert가 필요할듯
        }
    }
    
    @IBAction func EditAlertAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "출석부 편집", message: "OK버튼을 누르면 HIDE 체크된 사람은 출석부에서 숨겨지고 DELETE 체크된 사람은 출석부에서 완전히 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: EditConfirmAttendance(_:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func EditConfirmAttendance(_ sender: Any){
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/members/edit"
            
            var editParam : Array<EditData> = []
            for(key, value) in editDictionary{
                editParam.append(value)
            }
            let params = ReportEditPost(editActions: editParam, leaderUid: Auth.auth().currentUser!.uid)
                  
            let header: HTTPHeaders = [
                      "Content-Type": "application/json",
                      "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
                ]
                  
            let alamo = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: header).response { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    self.LoadAttendanceList(nav: "CURRENT")
                case .failure(let error):
                    print(error)
                    self.LoadAttendanceList(nav: "CURRENT")
                }
            }
                  // TODO : 변경이 완료되었습니다! 같은 Alert가 필요할듯
        }
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        // edit는 회원 여부 수정 할 때 필요함
        // 다른 곳에서 쓰고 있고 해당 코드는 나중에 다른 작업으로 바뀌어야 함
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload_edit), name: NSNotification.Name(rawValue: "update editBook"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update editBook"), object: self) // 초기화면 로드 (당일이 나와야 함)
    }
    
    @IBAction func prevButton(_ sender: Any) {
        LoadAttendanceList(nav: "PREV")
    }
    
    @IBAction func nextButton(_ sender: Any) {
        LoadAttendanceList(nav: "NEXT")
    }
    
    func SetStats(){
        var attendCnt = 0
        var allCnt = 0
        var attendPercent = 0.0
        
        allCnt = dailyAllAttendanceInfo.count
        
        if(allCnt == 0){
            statsText.text = "데이터가 없습니다."
            return
        }
        for (key, value) in dailyAllAttendanceInfo {
            if(dailyAllAttendanceInfo[key]?.hidden == true){
                allCnt -= 1
            }
            if(dailyAllAttendanceInfo[key]?.status == "ATTENDED"){
                attendCnt += 1
            }
        }
        
        print((attendCnt / allCnt))
        
        attendPercent = Double(attendCnt) / Double(allCnt) * 100.0
        statsText.text = "출석 \(attendCnt) / 전체 \(allCnt) / \(Int(attendPercent)) %"
    }
    
    // nav : PREV, CURRENT, NEXT
    func LoadAttendanceList(nav : String){
        // 서버에 지금 캠퍼스와 날짜를 보내줘야 함
        // 그러면 날짜 목록을 서버가 보내 줌
        //Alamofire
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/attendance/list"
            let date : String = SettingDate() // [NEEDED] DatePicker의 날자로 변경되어야 함
            let campusName : String = selectedCampus!
            let navpoint : String = nav
            
            let params : Parameters = [
                "date" : date,
                "campus" : campusName,
                "nav" : navpoint
            ]
            print(date)
            let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header)
            
            print(params)
            alamo.responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let results = json["data"].arrayValue
                    
                    if (results.count != 0){
                        var dateCheck = ""
                        print("success LOAD")
                        print("JSON: \(json)")
                        self.dailyAllAttendanceInfo.removeAll()

                        for result in results {
                            var temp = AttendanceInfo.init()
                            
                            temp.id = result["id"].stringValue
                            temp.date = result["date"].stringValue
                            temp.name = result["name"].stringValue
                            temp.mobile = result["mobile"].stringValue
                            temp.status = result["status"].stringValue
                            temp.note = result["note"].stringValue
                            temp.hidden = result["hidden"].bool
                            
                            self.dailyAllAttendanceInfo[String(temp.id!)] = temp
                            dateCheck = temp.date!
                        }
                        
                        self.datePicker.date = self.SettingString2Date(a: dateCheck)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                    } else{
                        if nav != "CURRENT" {
                            return
                        }
                        print("didn`t exist")
                        self.dailyAllAttendanceInfo.removeAll()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                        // alert라도 띄워주자 앞이나 뒤 정보가 더 없음
                    }
                case .failure(let error):
                    // Empty
                    self.isEmptyFlag = true
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                    
                    print(error)
                }
            }
        }
    }
    
    @objc func viewload(_ notification: Notification) {
        mainScrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: mainScrollView.frame)
        mainScrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        //makeAttendanceButton!.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        var makeButton = UIButton()
        
        if (self.isEmptyFlag == true){
            // [NEEDED] editButton 코드로 생성해 주세요..!
            makeButton.backgroundColor = UIColor.blue
            makeButton.frame = CGRect(x: view.frame.width/2 - 50, y: view.frame.height/2-50, width: 100, height: 100)
            makeButton.addTarget(self, action: #selector(self.MakeAttendance(_:)), for: .touchUpInside)
            
            mainScrollView.addSubview(makeButton)
            
            self.isEmptyFlag = false
            return
        }
        
        var inypos = 0
        let inxpos = 20
        var addCount = 0
        let sortedKeys = self.dailyAllAttendanceInfo.keys.sorted(by: <)
        for (key) in sortedKeys {
            if (dailyAllAttendanceInfo[key]?.hidden == true) {
                continue
            }
            var nextypos = 0
            let cellview = UIView()
            cellview.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(mainScrollView.frame.width), height: 80)
            
            //let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            //backgroundImage.image = UIImage(named: "몽산포_가로배너.png")
            
            //cellview.backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.5)
            
            mainScrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = dailyAllAttendanceInfo[key]?.name!
            namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            namelabel.textColor = UIColor.black
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 15, y: 7)
            cellview.addSubview(namelabel)
            
            ///agelabel
            let mobilelabel = UILabel()
            mobilelabel.text = dailyAllAttendanceInfo[key]?.mobile!
            mobilelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            mobilelabel.textColor = UIColor.black
            mobilelabel.sizeToFit()
            mobilelabel.frame.origin = CGPoint(x: 90, y: 7)
            cellview.addSubview(mobilelabel)
            
            
            attendRadioButtonArray.append(RadioButton.init())
            attendRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            attendRadioButtonArray[addCount].style = .rounded(radius: 4.0)
            attendRadioButtonArray[addCount].setTitle(key, for: .normal)
            if(dailyAllAttendanceInfo[key]?.status == "ATTENDED"){
                attendRadioButtonArray[addCount].setTitleColor(UIColor.white, for: .normal)
                attendRadioButtonArray[addCount].isOn = true
            } else{
                attendRadioButtonArray[addCount].setTitleColor(UIColor.white, for: .normal)
                attendRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
                attendRadioButtonArray[addCount].isOn = false
            }
            attendRadioButtonArray[addCount].frame = CGRect(x: 210, y: 4 , width: 30, height: 30)
            attendRadioButtonArray[addCount].addTarget(self, action: #selector(self.AttendAction(_:)), for: .touchUpInside)
            cellview.addSubview(attendRadioButtonArray[addCount])
            
            //textview///////////////////////////////////////
            
            let attendText = UITextView.init()
            attendText.frame.origin = CGPoint(x:250, y:4)
            attendText.frame.size = CGSize(width: mainScrollView.frame.width / 3, height: 30)
            attendText.text = dailyAllAttendanceInfo[key]?.note
            attendText.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 0.4)
            cellview.addSubview(attendText)
            attendTextDictionary[key] = attendText
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(mainScrollView.frame.width) - inxpos * 2, height: 120)
            let contentSize = textview.sizeThatFits(textview.bounds.size)
            var frame = textview.frame
            frame.size.height = max(contentSize.height, 10)
            textview.frame = frame
            textview.isScrollEnabled = false
            textview.isEditable = false
            textview.isUserInteractionEnabled = true
            textview.backgroundColor = UIColor.init(white: 0, alpha: 0)
            
            nextypos = Int(textview.frame.origin.y + textview.frame.size.height + 8)
            cellview.frame.size.height = CGFloat(nextypos)
            inypos += 3 + Int(cellview.frame.size.height) //다음 CellView의 위치
            //cellview.addSubview(textview)
            
            addCount += 1 // index
        }
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width-1, height: max(CGFloat(inypos),mainScrollView.frame.height+1))
        mainScrollView.isScrollEnabled = true
        
        if(dailyAllAttendanceInfo.count == 0){
            self.confirmButton.isEnabled = true
            self.confirmButton.setTitle("출석부 생성", for: .normal)
            self.confirmButton.removeTarget(nil, action: nil, for: .allEvents)
            self.confirmButton.addTarget(self, action: #selector(self.MakeAttendance(_:)), for: .touchUpInside)
        } else{
            self.confirmButton.isEnabled = true
            self.confirmButton.setTitle("출석 확인", for: .normal)
            self.confirmButton.removeTarget(nil, action: nil, for: .allEvents)
            self.confirmButton.addTarget(self, action: #selector(self.ConfirmButton(_:)), for: .touchUpInside)
        }
        
        SetStats()
        self.view.addSubview(mainScrollView)
    }
    
    @objc func viewload_edit(_ notification: Notification) {
        mainScrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: mainScrollView.frame)
        mainScrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        let infoTextView = UITextView()
        infoTextView.font = UIFont(name: "NotoSans", size: 13.0)!
        infoTextView.text = " HIDE : 출석명단에서 임시 제외 \n DELETE : 출석명단에서 완전 제거"
        infoTextView.frame = CGRect(x: 0, y: -5, width : Int(mainScrollView.frame.width), height: 80)
        mainScrollView.addSubview(infoTextView)
        
        let hideTextlabel = UILabel()
        hideTextlabel.text = "HIDE"
        hideTextlabel.font = UIFont(name: "NotoSans", size: 17.0)!
        hideTextlabel.textColor = UIColor.black
        hideTextlabel.sizeToFit()
        hideTextlabel.frame.origin = CGPoint(x: 225, y: 10)
        mainScrollView.addSubview(hideTextlabel)
        
        let deleteTextlabel = UILabel()
        deleteTextlabel.text = "DELETE"
        deleteTextlabel.font = UIFont(name: "NotoSans", size: 17.0)!
        deleteTextlabel.textColor = UIColor.black
        deleteTextlabel.sizeToFit()
        deleteTextlabel.frame.origin = CGPoint(x: 285, y: 10)
        mainScrollView.addSubview(deleteTextlabel)
        
        var inypos = 45
        let inxpos = 20
        var addCount = 0
        let sortedKeys = self.dailyAllAttendanceInfo.keys.sorted(by: <)
        for (key) in sortedKeys {
            var nextypos = 0
            let cellview = UIView()
            cellview.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(mainScrollView.frame.width), height: 80)
            
            mainScrollView.addSubview(cellview)
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = dailyAllAttendanceInfo[key]?.name!
            namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            namelabel.textColor = UIColor.black
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 15, y: 7)
            cellview.addSubview(namelabel)
            
            ///agelabel
            let mobilelabel = UILabel()
            mobilelabel.text = dailyAllAttendanceInfo[key]?.mobile!
            mobilelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            mobilelabel.textColor = UIColor.black
            mobilelabel.sizeToFit()
            mobilelabel.frame.origin = CGPoint(x: 90, y: 7)
            cellview.addSubview(mobilelabel)
            
            //hidden
            hiddenRadioButtonArray.append(RadioButton.init())
            hiddenRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            hiddenRadioButtonArray[addCount].style = .rounded(radius: 4.0)
            hiddenRadioButtonArray[addCount].setTitle(key, for: .normal)
            if(dailyAllAttendanceInfo[key]?.hidden == true){
                hiddenRadioButtonArray[addCount].setTitleColor(UIColor.white, for: .normal)
                hiddenRadioButtonArray[addCount].isOn = true
            } else{
                hiddenRadioButtonArray[addCount].setTitleColor(UIColor.white, for: .normal)
                hiddenRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
                hiddenRadioButtonArray[addCount].isOn = false
            }
            hiddenRadioButtonArray[addCount].frame = CGRect(x: 230, y: 4 , width: 30, height: 30)
            hiddenRadioButtonArray[addCount].addTarget(self, action: #selector(self.HiddenAction(_:)), for: .touchUpInside)
            cellview.addSubview(hiddenRadioButtonArray[addCount])
            
            //delete
            deleteRadioButtonArray.append(RadioButton.init())
            deleteRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            deleteRadioButtonArray[addCount].style = .rounded(radius: 4.0)
            deleteRadioButtonArray[addCount].setTitle(key, for: .normal)
            deleteRadioButtonArray[addCount].setTitleColor(UIColor.white, for: .normal)
            deleteRadioButtonArray[addCount].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            deleteRadioButtonArray[addCount].isOn = false
            deleteRadioButtonArray[addCount].frame = CGRect(x: 290, y: 4 , width: 30, height: 30)
            deleteRadioButtonArray[addCount].addTarget(self, action: #selector(self.DeleteAction(_:)), for: .touchUpInside)
            cellview.addSubview(deleteRadioButtonArray[addCount])
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(mainScrollView.frame.width) - inxpos * 2, height: 120)
            let contentSize = textview.sizeThatFits(textview.bounds.size)
            var frame = textview.frame
            frame.size.height = max(contentSize.height, 10)
            textview.frame = frame
            textview.isScrollEnabled = false
            textview.isEditable = false
            textview.isUserInteractionEnabled = true
            textview.backgroundColor = UIColor.init(white: 0, alpha: 0)
            
            nextypos = Int(textview.frame.origin.y + textview.frame.size.height + 8)
            cellview.frame.size.height = CGFloat(nextypos)
            inypos += 3 + Int(cellview.frame.size.height) //다음 CellView의 위치
            //cellview.addSubview(textview)
            
            addCount += 1 // index
        }
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width-1, height: max(CGFloat(inypos),mainScrollView.frame.height+1))
        mainScrollView.isScrollEnabled = true
        
        self.confirmButton.isEnabled = true
        self.confirmButton.setTitle("편집 완료", for: .normal)
        self.confirmButton.removeTarget(nil, action: nil, for: .allEvents)
        self.confirmButton.addTarget(self, action: #selector(self.EditAlertAction(_:)), for: .touchUpInside)
        
        
        self.SetStats()
        self.view.addSubview(mainScrollView)
    }
    
    // gray : NOT CHECKED
    // blue : ATTENDED
    // black : ABSENT
    @objc func AttendAction(_ sender:RadioButton){
        let keyNumber = sender.currentTitle
        let checkMember = self.dailyAllAttendanceInfo[String(keyNumber!)]

        if (checkMember?.status == "ATTENDED"){
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = false
            SettingSendAttendData(idx: sender.currentTitle!, check: "ABSENT")
        } else{
            sender.bounceIn()
            SettingSendAttendData(idx: sender.currentTitle!, check: "ATTENDED")
        }
    }
    
    // SHOW
    // HIDE
    // DELETE
    @objc func HiddenAction(_ sender:RadioButton){
        let keyNumber = sender.currentTitle
        var temp = EditData(id: Int(keyNumber!)!, action: "")
        if dailyAllAttendanceInfo[String(keyNumber!)]?.hidden == false {
            dailyAllAttendanceInfo[String(keyNumber!)]?.hidden = true
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = true
            temp.action = "HIDE"
        } else{
            dailyAllAttendanceInfo[String(keyNumber!)]?.hidden = false
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = false
            temp.action = "SHOW"
        }
        self.editDictionary[String(keyNumber!)] = temp
    }
    
    @objc func DeleteAction(_ sender:RadioButton){
        let keyNumber = sender.currentTitle
        var temp = EditData(id: Int(keyNumber!)!, action: "")
        if(editDictionary[keyNumber!]?.action == "DELETE"){
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = false
            temp.action = "SHOW"
        } else{
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = true
            temp.action = "DELETE"
        }
        self.editDictionary[String(keyNumber!)] = temp
    }
    
    func SettingSendAttendData(idx : String, check : String){
        // Client 에서 출석 상태 변경
        if(check == "ATTENDED"){
            self.dailyAllAttendanceInfo[idx]?.status = "ATTENDED"
        } else{
            self.dailyAllAttendanceInfo[idx]?.status = "ABSENT"
        }
        SetStats()
    }
    
    func SettingSendAttandanceList() -> Array<AttendanceData> {
        var sendAttendanceArray : Array<AttendanceData> = []
        var data : AttendanceData
        var addCount = 0
        let sortedKeys = self.dailyAllAttendanceInfo.keys.sorted(by: <)
        for (key) in sortedKeys{
            if(dailyAllAttendanceInfo[key]?.hidden == true){
                continue
            }
            data = AttendanceData(id: Int((dailyAllAttendanceInfo[key]?.id!)!)!, status: (dailyAllAttendanceInfo[key]?.status!)!, note: ((attendTextDictionary[key]!.text)!))
            sendAttendanceArray.append(data)
            addCount+=1
        }
        
        return sendAttendanceArray
    }
    
    func saveCurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = dateFormatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveCurrentDate() // [NEEDED] DatePicker로 계속 변경되어야 하고 처음에는 오늘날자로 적용 되도록
        
        LoadAttendanceList(nav: "CURRENT")
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "update AttendanceBook"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self) // 초기화면 로드 (당일이 나와야 함)
    }
}
