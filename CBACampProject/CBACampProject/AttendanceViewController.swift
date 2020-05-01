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

struct ReportAttendancePost: Encodable {
    var checkList : Array<AttendanceData>
    var leaderUid : String
}

struct AttendanceData: Encodable {
    var id : Int
    var status : String
    var note : String
}

class AttendanceViewController: UIViewController {
    @IBOutlet weak var statsText: UILabel!
    @IBOutlet weak var campusName: UILabel!
    @IBOutlet weak var attendanceScrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var makeAttendanceButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
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
                    
                    self.currentAttendanceInfo.removeAll()
                    
                    for result in results {
                        var test = AttendanceInfo.init()
                        
                        test.id = result["id"].stringValue
                        test.date = result["date"].stringValue
                        test.name = result["name"].stringValue
                        test.mobile = result["mobile"].stringValue
                        test.status = result["status"].stringValue
                        test.note = result["note"].stringValue
                        
                        self.currentAttendanceInfo[String(test.id!)] = test
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    @IBAction func makeAttendanceAction(_ sender: Any) {
       
    }
    
    var selectedCampus : String?
    var currentAttendanceInfo : Dictionary<String, AttendanceInfo> = [:]
    var sendAttendanceArray : Array<AttendanceData> = [:]
    var checkAttendance : Array<Parameters> = []
    var attendButtonArray : Array<RadioButton> = []
    var textArray : Array<UITextView> = []
    
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
            
            var params = ReportAttendancePost(checkList: sendAttendanceArray, leaderUid: Auth.auth().currentUser!.uid)
            
            print("Confirm Param")
            print(params)
            
            let header: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
            ]
            
            let alamo = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: header).response {
                response in debugPrint(response)
            }
            
            // TODO : 변경이 완료되었습니다! 같은 Alert가 필요할듯
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        // edit는 회원 여부 수정 할 때 필요함
        // 다른 곳에서 쓰고 있고 해당 코드는 나중에 다른 작업으로 바뀌어야 함
    }
    
    @IBAction func prevButton(_ sender: Any) {
        LoadAttendanceList(nav: "PREV")
    }
    
    @IBAction func nextButton(_ sender: Any) {
        LoadAttendanceList(nav: "NEXT")
    }
    
    func setStats(){
        var attendCnt = 0
        var allCnt = 0
        var attendPercent = 0.0
        
        allCnt = currentAttendanceInfo.count
        
        if(allCnt == 0){
            statsText.text = "데이터가 없습니다."
            return
        }
        for (key, value) in currentAttendanceInfo {
            if(currentAttendanceInfo[key]?.status == "ATTENDED"){
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
                        self.currentAttendanceInfo.removeAll()

                        for result in results {
                            var test = AttendanceInfo.init()
                            
                            test.id = result["id"].stringValue
                            test.date = result["date"].stringValue
                            test.name = result["name"].stringValue
                            test.mobile = result["mobile"].stringValue
                            test.status = result["status"].stringValue
                            test.note = result["note"].stringValue
                            
                            self.currentAttendanceInfo[String(test.id!)] = test
                            dateCheck = test.date!
                        }
                        
                        self.datePicker.date = self.SettingString2Date(a: dateCheck)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self)
                    } else{
                        if nav != "CURRENT" {
                            return
                        }
                        print("didn`t exist")
                        self.currentAttendanceInfo.removeAll()
                        
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
        // 뷰가 바뀌는거면 체크 하던거 의미 없어지니 지워
        sendAttendanceArray.removeAll()
        checkAttendance.removeAll()
        
        attendanceScrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: attendanceScrollView.frame)
        attendanceScrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        //makeAttendanceButton!.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        var makeButton = UIButton()
        
        if (self.isEmptyFlag == true){
            // [NEEDED] editButton 코드로 생성해 주세요..!
            makeButton.backgroundColor = UIColor.blue
            makeButton.frame = CGRect(x: view.frame.width/2 - 50, y: view.frame.height/2-50, width: 100, height: 100)
            makeButton.addTarget(self, action: #selector(self.MakeAttendance(_:)), for: .touchUpInside)
            
            attendanceScrollView.addSubview(makeButton)
            
            self.isEmptyFlag = false
            return
        }
        
        var inypos = 0
        let inxpos = 20
        let count = currentAttendanceInfo.count
        
        var i = 0
        for (key, value) in currentAttendanceInfo {
            var nextypos = 0
            let cellview = UIView()
            
            //cellview.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(attendanceScrollView.frame.width), height: 80)
            
            //let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            //backgroundImage.image = UIImage(named: "몽산포_가로배너.png")
            
            cellview.backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.5)
            
            attendanceScrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = currentAttendanceInfo[key]?.name!
            namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            namelabel.textColor = UIColor.black
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 15, y: 7)
            cellview.addSubview(namelabel)
            
            ///agelabel
            let mobilelabel = UILabel()
            mobilelabel.text = currentAttendanceInfo[key]?.mobile!
            mobilelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            mobilelabel.textColor = UIColor.black
            mobilelabel.sizeToFit()
            mobilelabel.frame.origin = CGPoint(x: 90, y: 7)
            cellview.addSubview(mobilelabel)
            
            
            attendButtonArray.append(RadioButton.init())
            attendButtonArray[i].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            attendButtonArray[i].style = .square
            attendButtonArray[i].setTitle(key, for: .normal)
            if(currentAttendanceInfo[key]?.status == "ATTENDED"){
                attendButtonArray[i].setTitleColor(UIColor.black, for: .normal)
                attendButtonArray[i].isOn = true
            } else{
                attendButtonArray[i].setTitleColor(UIColor.blue, for: .normal)
                attendButtonArray[i].radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
                attendButtonArray[i].isOn = false
            }
            attendButtonArray[i].frame = CGRect(x: 210, y: 4 , width: 30, height: 30)
            attendButtonArray[i].addTarget(self, action: #selector(self.AttendAction(_:)), for: .touchUpInside)
            cellview.addSubview(attendButtonArray[i])
            
            //textview///////////////////////////////////////
            textArray.append(UITextView.init())
            textArray[i].frame.origin = CGPoint(x:250, y:4)
            textArray[i].frame.size = CGSize(width: 100, height: 30)
            textArray[i].backgroundColor = UIColor.white
            textArray[i].text = currentAttendanceInfo[key]?.note
            cellview.addSubview(textArray[i])
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(attendanceScrollView.frame.width) - inxpos * 2, height: 120)
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
            
            i += 1 // index
        }
        attendanceScrollView.contentSize = CGSize(width: attendanceScrollView.frame.width-1, height: max(CGFloat(inypos),attendanceScrollView.frame.height+1))
        attendanceScrollView.isScrollEnabled = true
        
        if(currentAttendanceInfo.count == 0){
            self.confirmButton.isEnabled = true
            self.confirmButton.setTitle("출석부 생성", for: .normal)
            self.confirmButton.addTarget(self, action: #selector(self.MakeAttendance(_:)), for: .touchUpInside)
        } else{
            self.confirmButton.isEnabled = true
            self.confirmButton.setTitle("출석 확인", for: .normal)
            self.confirmButton.addTarget(self, action: #selector(self.ConfirmButton(_:)), for: .touchUpInside)
        }
        
        setStats() // Title 표시
        self.view.addSubview(attendanceScrollView)
    }
    
    // gray : NOT CHECKED
    // blue : ATTENDED
    // black : ABSENT
    @objc func AttendAction(_ sender:RadioButton){
        let keyNumber = sender.currentTitle
        let checkMember = self.currentAttendanceInfo[String(keyNumber!)]

        if (checkMember?.status == "ATTENDED"){
            sender.radioCircle = .init(outerCircle: 20.0, innerCircle: 15.0)
            sender.isOn = false
            SettingSendAttendData(idx: sender.currentTitle!, check: "ABSENT")
        } else{
            sender.bounceIn()
            SettingSendAttendData(idx: sender.currentTitle!, check: "ATTENDED")
        }
    }
    
    func SettingSendAttendData(idx : String, check : String){
        // Client 에서 출석 상태 변경
        if(check == "ATTENDED"){
            self.currentAttendanceInfo[idx]?.status = "ATTENDED"
        } else{
            self.currentAttendanceInfo[idx]?.status = "ABSENT"
        }
        
        // 서버로 보낼 데이터 저장
        let json = AttendanceData(id : Int(idx)!, status : check, note : currentAttendanceInfo[idx]?.note ?? "")
        
        sendAttendanceArray.append(json)
        
        print(sendAttendanceArray)
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
        campusName.text = selectedCampus
        
        LoadAttendanceList(nav: "CURRENT")
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "update AttendanceBook"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update AttendanceBook"), object: self) // 초기화면 로드 (당일이 나와야 함)
    }
}
