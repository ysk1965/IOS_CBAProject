//
//  MassageTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import Firebase

class MassageTabViewController: UIViewController {
    @IBOutlet weak var infoText: UITextField!
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
    
    @IBOutlet weak var ApplicationOutlet: UIButton!
    @IBAction func ApplicationAction(_ sender: Any) {
        //ApplicationOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        //UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var ApplicationLabel: UILabel!
    
    lazy var SendButton = UIButton()
    
    @objc func viewload(_ notification: Notification) {
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: scrollView.frame)
        
        scrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        var inypos = self.view.frame.height/10
        let inxpos = 20
        let count = FirebaseModel.messages.count
        

        if(CBAInfoTabViewController.isNotiMessage == false){
            for i in 0..<count {
                var nextypos = 0
                let cellview = UIView()
                let infoLabel = UILabel()
                let messageImage = UIImageView()
                
                //info Label
                infoLabel.text = FirebaseModel.messages[count - i - 1].auth + "   " + FirebaseModel.messages[count - i - 1].time
                infoLabel.font = UIFont(name:"NotoSansUI", size: 14.0)!
                infoLabel.textColor = UIColor.black
                infoLabel.sizeToFit()
                
                cellview.layer.borderWidth = 0
                // Backgroud Iamge Setting
                if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                    messageImage.image = UIImage(named : "본부에서보낼때.png")
                    messageImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    cellview.addSubview(messageImage)
                    
                    cellview.frame = CGRect(x: 0, y: Int(inypos), width : Int(scrollView.frame.width * 0.8), height: 80)
                    
                    infoLabel.frame.origin = CGPoint(x: Int(self.view.frame.width/15), y: nextypos - 20)
                } else if(FirebaseModel.messages[count - i - 1].uid != AgencySingleton.shared.realmUid){
                    messageImage.image = UIImage(named : "다른-영혼이-보낼때.png")
                    messageImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    cellview.addSubview(messageImage)
                    
                    cellview.frame = CGRect(x: 0, y: Int(inypos), width : Int(scrollView.frame.width * 0.8), height: 80)
                    
                    infoLabel.frame.origin = CGPoint(x: Int(self.view.frame.width/15), y: nextypos - 20)
                }else{
                    messageImage.image = UIImage(named : "내가-보낼때.png")
                    messageImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    cellview.addSubview(messageImage)
                    cellview.frame = CGRect(x: Int(scrollView.frame.width * 0.2), y: Int(inypos), width : Int(scrollView.frame.width * 0.8), height: 80)
                    
                    
                    ///InfoLabel
                    infoLabel.frame.origin = CGPoint(x: Int(cellview.frame.width - infoLabel.frame.width) - inxpos, y: nextypos - 20)
                }
                scrollView.addSubview(cellview)
                cellview.addSubview(infoLabel)
                
                //textview///////////////////////////////////////
                let textView = UITextView()
                textView.text = FirebaseModel.messages[count - i - 1].text
                textView.font = UIFont(name: "NotoSans", size: 18.0)!
                if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                    textView.textColor = UIColor.white
                    textView.frame.origin = CGPoint(x:inxpos + Int(self.view.frame.width * 0.02), y:nextypos)
                    textView.bounceIn(from:.left,delay:0.3)
                    cellview.bounceIn(from:.left,delay:0.3)
                    infoLabel.bounceIn(from:.left,delay:0.3)
                    messageImage.bounceIn(from:.left,delay:0.3)
                } else{
                    textView.frame.origin = CGPoint(x:inxpos, y:nextypos)
                    textView.bounceIn(from:.right,delay:0.3)
                    cellview.bounceIn(from:.right,delay:0.3)
                    infoLabel.bounceIn(from:.right,delay:0.3)
                    messageImage.bounceIn(from:.right,delay:0.3)
                }
                textView.frame.size = CGSize(width: Int(self.view.frame.width * 0.7), height: 30)
                let contentSize = textView.sizeThatFits(textView.bounds.size)
                var frame = textView.frame
                textView.backgroundColor = UIColor.init(white: 1, alpha: 0)
                textView.isScrollEnabled = false
                textView.isEditable = false
                textView.isUserInteractionEnabled = true
                frame.size.height = max(contentSize.height, 30)
                textView.frame = frame
                textView.isUserInteractionEnabled = true
                nextypos = Int(textView.frame.origin.y + textView.frame.size.height + 8)
                
                nextypos += Int(infoLabel.frame.size.height) - 10
                
                cellview.frame.size.height = CGFloat(nextypos)
                inypos += 35 + cellview.frame.size.height //다음 CellView의 위치
                cellview.addSubview(textView)
            }

        } else{
            inypos = 0
            for i in 0..<count {
                var nextypos = 0
                let cellview = UIView()
                if(FirebaseModel.messages[count - i - 1].isStaff == "공지"){
                    cellview.layer.borderColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0).cgColor
                    cellview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
                } else if (FirebaseModel.messages[count - i - 1].isStaff == "봉사자"){
                    cellview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
                } else{
                    cellview.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
                    cellview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
                }
                cellview.layer.borderWidth = 0
                
                cellview.frame = CGRect(x: 0, y: Int(inypos), width : Int(scrollView.frame.width), height: 80)
                scrollView.addSubview(cellview)
                
                //profile image, rank name label, name label //////////////////////////////
                let profileimgview = UIImageView()
                profileimgview.frame = CGRect(x:20, y:20, width: 40, height: 40)
                profileimgview.contentMode = UIView.ContentMode.scaleAspectFill
                profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
                if (FirebaseModel.messages[count - i - 1].isStaff == "공지") {
                    profileimgview.image = UIImage(named: "성락아이콘.png") // 스탭 이미지
                } else if (FirebaseModel.messages[count - i - 1].isStaff == "봉사자"){
                    profileimgview.image = UIImage(named: "성락아이콘.png") // 스탭 이미지
                } else {
                    profileimgview.image = UIImage(named:"성락아이콘.png")
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
                    textview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
                } else{
                    textview.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
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
                inypos += 7 + cellview.frame.size.height //다음 CellView의 위치
                cellview.addSubview(textview)
            }
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width-1, height: max(CGFloat(inypos),scrollView.frame.height-inypos))
        scrollView.tintColor = UIColor.white
        
        scrollView.isScrollEnabled = true
        
        self.view.addSubview(scrollView)
        
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x:0,y:0,width:self.view.frame.width, height: self.view.frame.height)
        backgroundImage.alpha = 0.3
        backgroundImage.image = UIImage(named: AgencySingleton.shared.backgroundImageName!)
        self.view.addSubview(backgroundImage)
        
        
        if(CBAInfoTabViewController.isNotiMessage == false) {
            let infoText = UILabel()
            infoText.frame = CGRect(x:0, y:self.view.frame.height/9, width:self.view.frame.width, height:self.view.frame.height/13)
            infoText.font = UIFont(name: "System"
                , size: 11)
            infoText.adjustsFontSizeToFitWidth = true
            infoText.textColor = UIColor.lightGray
            infoText.textAlignment = .center
            infoText.numberOfLines = 2
            if(AgencySingleton.shared.AgencyTitle == "2019_SR_SUMMER"){
                infoText.text = """
                작성하신 내용은 작성자와 관리자만 확인되면
                처리 경과를 확인하실 수 있습니다.
                """
            } else{
                infoText.text = """
                수련회 동안 생활하는 데 불편사항 및 건의를
                보내주시면 확인후 답변해드립니다.
                """
            }
            view.addSubview(infoText)
            
            SendButton.setTitle(" ", for: .normal)
            SendButton.setTitleColor(UIColor.blue, for: .normal)
            SendButton.popIn()
            SendButton.frame = CGRect(x: scrollView.frame.width-95, y: scrollView.frame.height-95, width: 75, height: 75)
            SendButton.setBackgroundImage(UIImage(named: "메세지-아이콘.png"), for: .normal)
            SendButton.addTarget(self, action: #selector(self.Send(_:)), for: .touchUpInside)
            self.view.addSubview(SendButton)
        }
        
        CBAInfoTabViewController.isNotiMessage = false
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func viewDidLoad() {
        if(CBAInfoTabViewController.isNotiMessage == false){
            FirebaseModel().FIR_GetMessage(messageTitle: "message")
        } else{
            FirebaseModel().FIR_GetMessage(messageTitle: "noti")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "FIR_GetMessage"), object: nil)
        
        Messaging.messaging().subscribe(toTopic: "2019winter") { error in
            print("Subscribed to 2019winter topic")
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

