//
//  AttendanceViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 5. 13..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        id = "a"
        date = "a"
        name = "a"
        mobile = "a"
        status = "a"
        note = "a"
    }
}

struct checkAPI {
    var id : String?
    var status : String?
    var note : String?
}

/*
struct ConfirmInfo: Codable {
    var checklist : Array<checkAPI> = []
    var leaderUid : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checklist = try values.decodeIfPresent(Array<checkAPI>.self, forKey: .id)
        leaderUid = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
    init() {
        var tempAPI : checkAPI
        tempAPI.id = "test"
        tempAPI.note = "testNote"
        tempAPI.status = "testStatus"
        
        checklist.append(tempAPI)
        
        leaderUid = "tempUid"
    }
}
*/

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
    
    
    @IBAction func ConfirmButton(_ sender: Any) {
        for n in 0...currentAttendanceInfo.count - 1{
            currentAttendanceInfo[n].note = textArray[n].text
        }
        // 변경완료
        // text는 여기서 다 불러서 저장해
        for n in 0...currentAttendanceInfo.count - 1{
            print(currentAttendanceInfo[n].note!)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        // 편집기능이 들어갈 버튼
    }
    
    @IBAction func prevButton(_ sender: Any) {
        // 오늘 날짜를 보내고 이전 가장 최근 날짜를 받아와
    }
    @IBAction func nextButton(_ sender: Any) {
    }
    
    struct requestAPI{
        var date : String
        var campus : String
    }
    
    var attendCnt : Int = 5
    var allCnt : Int = 5
    var attendPercent : Int = 5
    func setStats(){
        attendPercent = attendCnt / allCnt * 100
        statsText.text = "출석 \(attendCnt) / 전체 \(allCnt) / \(attendPercent) %"
    }
    
    func loadDateList(){
        // 서버에 지금 캠퍼스와 날짜를 보내줘야 함
        // 그러면 날짜 목록을 서버가 보내 줌
        
        //Parsing
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/attendance/list"
            let urlObj = URL(string: url)
            // Get으로 requestAPI 쏴서 받는거 알아야 함
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let getAttendanceArray = try decoder.decode(AttendanceInfo.self, from: data)
                    
                    //self.currentAttendanceInfo = getAttendanceArray
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
            }.resume()
        }
    }
    
    func loadAttendanceData(){
        // 받아온 데이터 중 가장 최근 날짜를 우선 뿌려줘야 해
        // 이번엔 서버에 해당 날짜 + 캠퍼스를 보내줘
        // 서버는 출석부를 건내줄거야
        
        //Parsing
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/attendance/list"
            let urlObj = URL(string: url)
            // Get으로 requestAPI 쏴서 받는거 알아야 함
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let getAttendanceArray = try decoder.decode(
                        Array<AttendanceInfo>.self, from: data)
                    
                    self.currentAttendanceInfo = getAttendanceArray
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
    }
    
    func testFunc(){
        var test = AttendanceInfo.init()

        for n in 1...20{
            test.name = "유상건이"
            test.mobile = "010-0000-0000"
            test.status = ""
            currentAttendanceInfo.append(test)
        }
    }
    
    @objc func viewload(_ notification: Notification) {
        attendanceScrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: attendanceScrollView.frame)
        attendanceScrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
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
        
        self.view.addSubview(attendanceScrollView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func Attend(_ sender:UIButton){
        // 출석에 대한 정의가 필요합니다.
        if(sender.backgroundColor == UIColor.black){
            sender.backgroundColor = UIColor.blue
            renewAttend(idx: Int(sender.currentTitle!) ?? errorCode, check: "ABSENT")
        } else{
            sender.backgroundColor = UIColor.black
            renewAttend(idx: Int(sender.currentTitle!) ?? errorCode, check: "ATTENDED")
        }
    }
    
    func renewAttend(idx : Int, check : String){
        currentAttendanceInfo[idx].status = String(check)
    }
    
    func renewNote(idx : Int, value : String){
        currentAttendanceInfo[idx].note = String(value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateList()
        campusName.text = selectedCampus
        testFunc()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got GBS"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got GBS"), object: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
