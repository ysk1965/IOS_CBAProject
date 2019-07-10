//
//  MassageTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import Firebase

struct MyInfo: Codable {
    let campus : String?
    let name : String?
    let mobile : String?
    let age : Int?
    let gbsLevel : String?
    let grade : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        campus = try values.decodeIfPresent(String.self, forKey: .campus)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        gbsLevel = try values.decodeIfPresent(String.self, forKey: .gbsLevel)
        grade = try values.decodeIfPresent(String.self, forKey: .grade)
    }
}

struct MyGBS: Codable {
    let gbsLevel : String?
    let leader: UserInfo?
    let members : [UserInfo]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gbsLevel = try values.decodeIfPresent(String.self, forKey: .gbsLevel)
        leader = try values.decodeIfPresent(UserInfo.self, forKey: .leader)
        members = try values.decodeIfPresent([UserInfo].self, forKey: .members)
    }
}

struct UserInfo: Codable{
    let name : String?
    let age : Int?
    let campus : String?
    let mobile : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        campus = try values.decodeIfPresent(String.self, forKey: .campus)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
    }
}

class MassageTabViewController: UIViewController {
    @IBOutlet weak var Hamberger: UIButton!
    @IBAction func HambergerAction(_ sender: Any) {
        Hamberger.popIn(fromScale: 1.5, duration: 2, delay: 0)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBAction func Back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    var url = URL(string:"http://cba.sungrak.or.kr/RetreatSite/RetreatAdd")
    static var mainUser = MainUser(age: 0, campus: "", mobile: "", name: "", gbsLevel : "", grade: "")
    static var mainGBS = MainGBS(gbsLevel: "", leader: nil, members: nil)
    static var memberCount = Int(0)
    
    @IBOutlet weak var ApplicationOutlet: UIButton!
    @IBAction func ApplicationAction(_ sender: Any) {
        //ApplicationOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        //UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var ApplicationLabel: UILabel!
    
    
    @objc func viewload(_ notification: Notification) {
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: scrollView.frame)
        
        scrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        var inypos = 2
        let inxpos = 20
        let count = FirebaseModel.messages.count
        
        for i in 0..<count {
            var nextypos = 0
            let cellview = UIView()
            if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                cellview.layer.borderColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0).cgColor
            } else{
                cellview.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
            }
            cellview.layer.borderWidth = 0
            
            if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                cellview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
            } else if (FirebaseModel.messages[count - i - 1].isStaff == "봉사자"){
                cellview.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            }
            else{
                cellview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(scrollView.frame.width), height: 80)
            scrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            let profileimgview = UIImageView()
            profileimgview.frame = CGRect(x:20, y:20, width: 40, height: 40)
            profileimgview.contentMode = UIViewContentMode.scaleAspectFill
            profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
            if (FirebaseModel.messages[count - i - 1].isStaff == "공지") {
                profileimgview.image = UIImage(named: "19겨울_앱로고.png") // 스탭 이미지
            } else if (FirebaseModel.messages[count - i - 1].isStaff == "봉사자"){
                profileimgview.image = UIImage(named: "19겨울_앱로고.png") // 스탭 이미지
            } else {
                profileimgview.image = UIImage(named:"profile.png")
            }
            profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
            cellview.addSubview(profileimgview)
            nextypos = Int(profileimgview.frame.origin.y + profileimgview.frame.size.height + 15)
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = FirebaseModel.messages[count - i - 1].auth
            namelabel.font = UIFont(name: "NotoSans-Bold", size: 17.0)!
            if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                namelabel.textColor = UIColor.black
            } else{
                namelabel.textColor = UIColor.black
            }
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 70, y: 20)
            cellview.addSubview(namelabel)
            
            
            ///ranknamelabel
            let ranknamelabel = UILabel()
            ranknamelabel.text = "진리수호 교회수호"
            ranknamelabel.font = UIFont(name:"NotoSans-Bold", size: 14.0)
            ranknamelabel.textColor = UIColor.darkGray
            ranknamelabel.sizeToFit()
            ranknamelabel.frame.origin = CGPoint(x:70, y: 43)
            cellview.addSubview(ranknamelabel)
            
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.text = FirebaseModel.messages[count - i - 1].text
            textview.font = UIFont(name: "NotoSans", size: 18.0)!
            if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                textview.textColor = UIColor.black
            } else{
                textview.textColor = UIColor.black
            }
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(scrollView.frame.width) - inxpos * 2, height: 30)
            let contentSize = textview.sizeThatFits(textview.bounds.size)
            var frame = textview.frame
            frame.size.height = max(contentSize.height, 30)
            textview.frame = frame
            //let aspectRatioTextViewConstraint = NSLayoutConstraint(item: textview, attribute: .height, relatedBy: .equal, toItem: textview, attribute: .width, multiplier: textview.bounds.height/textview.bounds.width, constant: 1)
            //textview.addConstraint(aspectRatioTextViewConstraint)
            textview.isScrollEnabled = false
            textview.isEditable = false
            textview.isUserInteractionEnabled = true
            nextypos = Int(textview.frame.origin.y + textview.frame.size.height + 8)
            if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                textview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
            } else if (FirebaseModel.messages[count - i - 1].isStaff == "봉사자"){
                textview.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            } else{
                textview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            
            ///timelabel
            let timelabel = UILabel()
            timelabel.text = FirebaseModel.messages[count - i - 1].time
            timelabel.font = UIFont(name:"NotoSansUI", size: 14.0)!
            timelabel.textColor = UIColor.lightGray
            timelabel.sizeToFit()
            timelabel.frame.origin = CGPoint(x: Int(cellview.frame.width - timelabel.frame.width) - inxpos, y: nextypos)
            cellview.addSubview(timelabel)
            
            nextypos += Int(timelabel.frame.size.height) + 12
            
            
            //buttonView.addSubview(SendButton)
            
            
            cellview.frame.size.height = CGFloat(nextypos)
            inypos += 7 + Int(cellview.frame.size.height) //다음 CellView의 위치
            cellview.addSubview(textview)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width-1, height: max(CGFloat(inypos),scrollView.frame.height+1))
        
        
        let backImage = UIImageView()
        backImage.image = UIImage(named : "19겨울_메세지배경.png")
        backImage.alpha = 0.2
        backImage.frame.size = scrollView.frame.size
        backImage.frame.size.height = scrollView.contentSize.height
        scrollView.addSubview(backImage)
        
        scrollView.isScrollEnabled = true
        
        self.view.addSubview(scrollView)
        
        // add Button
        let SendButton = UIButton()
        SendButton.setTitle(" ", for: .normal)
        SendButton.setTitleColor(UIColor.blue, for: .normal)
        //SendButton.backgroundColor = UIColor.black
        SendButton.frame = CGRect(x: scrollView.frame.width-85, y: scrollView.frame.height-85, width: 75, height: 75)
        SendButton.setBackgroundImage(UIImage(named: "KakaoTalk_Photo_2019-01-14-11-35-56.png"), for: .normal)
        SendButton.addTarget(self, action: #selector(self.Send(_:)), for: .touchUpInside)
        self.view.addSubview(SendButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got messages"), object: nil)
        FirebaseModel().getMessages(messageTitle: "message")
        
        Messaging.messaging().subscribe(toTopic: "2019winter") { error in
            print("Subscribed to 2019winter topic")
        }
    }

    func parsing(){
        // DataPassing
        print("parsing start")
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)!
            let urlObj = URL(string: url)
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    var myinfos = try decoder.decode(MyInfo.self, from: data)
                    
                    if(myinfos.age != nil){
                        MassageTabViewController.mainUser.setUser(age: myinfos.age!, campus: myinfos.campus!, mobile: myinfos.mobile!, name: myinfos.name!, gbsLevel: myinfos.gbsLevel!, grade: myinfos.grade!)
                    }
                    
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/getGBSInfo/" + (Auth.auth().currentUser?.uid)!
            let urlObj = URL(string: url)
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let myinfos = try decoder.decode(MyGBS.self, from: data)
                    
                    if(myinfos.gbsLevel != nil){
                        MassageTabViewController.mainGBS.setGBS(gbsLevel: myinfos.gbsLevel!, leader: myinfos.leader!, members: myinfos.members!)
                        MassageTabViewController.memberCount = myinfos.members!.count
                    }
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
            }.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func Send(_ sender:UIButton){
        ////////////////////
        let sendLabel = UILabel()
        sendLabel.text = " "
        sendLabel.font = UIFont(name:"NotoSansUI", size: 14.0)!
        sendLabel.textColor = UIColor.lightGray
        sendLabel.sizeToFit()
        sendLabel.frame = CGRect(x: scrollView.frame.width-65, y: scrollView.frame.height-5, width: 50, height: 50)
        self.view.addSubview(sendLabel)
        sendLabel.popIn()
        
        self.performSegue(withIdentifier: "ChatPageSegue", sender: nil)
        
        //dismiss(animated: true, completion: nil)
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

