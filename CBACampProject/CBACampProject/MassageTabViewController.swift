//
//  MassageTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit

class MassageTabViewController: UIViewController {
    @IBOutlet weak var Hamberger: UIButton!
    @IBAction func HambergerAction(_ sender: Any) {
        Hamberger.popIn(fromScale: 1.5, duration: 2, delay: 0)
    }

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var url = URL(string:"http://cbapray.sungrak.or.kr/RetreatSite/RetreatAdd")
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SegueToSideMenu"{
            if let navController = segue.destination as? UINavigationController{
                if let SideMenuController = navController.topViewController as?
                    SideBarViewController {
                    SideMenuController.Check = true
                }
            }
        }
    }
    
    @IBOutlet weak var ApplicationOutlet: UIButton!
    @IBAction func ApplicationAction(_ sender: Any) {
        ApplicationOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var ApplicationLabel: UILabel!
    
    
    @objc func viewload(_ notification: Notification) {
        ApplicationOutlet.frame.origin.x = self.view.frame.size.width - 42
        ApplicationOutlet.frame.origin.y = 20
        ApplicationLabel.frame.origin.x = self.view.frame.size.width - 52
        ApplicationLabel.frame.origin.y = 50
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: scrollView.frame)
        scrollView.addSubview(scrollcontainerView)
        
        var inypos = 2
        let inxpos = 20
        let count = FirebaseModel.messages.count
        for i in 0..<count {
            var nextypos = 0
            let cellview = UIView()
            cellview.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
            cellview.layer.borderWidth = 1
            cellview.backgroundColor = UIColor.white
            
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(scrollView.frame.width), height: 80)
            scrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            let profileimgview = UIImageView()
            profileimgview.frame = CGRect(x:20, y:20, width: 40, height: 40)
            profileimgview.contentMode = UIViewContentMode.scaleAspectFill
            profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
            if (FirebaseModel.messages[count - i - 1].auth == "STAFF") {
                profileimgview.image = UIImage(named: "Icon-60@3x.png")
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
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 70, y: 20)
            cellview.addSubview(namelabel)
            
            
            ///ranknamelabel
            let ranknamelabel = UILabel()
            ranknamelabel.text = "환언, 우리의 사명"
            ranknamelabel.font = UIFont(name:"NotoSans-Bold", size: 14.0)
            ranknamelabel.textColor = UIColor.lightGray
            ranknamelabel.sizeToFit()
            ranknamelabel.frame.origin = CGPoint(x:70, y: 43)
            cellview.addSubview(ranknamelabel)
            
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.text = FirebaseModel.messages[count - i - 1].text
            textview.font = UIFont(name: "NotoSans", size: 18.0)!
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
            
            
            ///timelabel
            let timelabel = UILabel()
            timelabel.text = FirebaseModel.messages[count - i - 1].time
            timelabel.font = UIFont(name:"NotoSansUI", size: 14.0)!
            timelabel.textColor = UIColor.lightGray
            timelabel.sizeToFit()
            timelabel.frame.origin = CGPoint(x: Int(cellview.frame.width - timelabel.frame.width) - inxpos, y: nextypos)
            cellview.addSubview(timelabel)
            
            nextypos += Int(timelabel.frame.size.height) + 12
            
            
            cellview.frame.size.height = CGFloat(nextypos)
            inypos += 7 + Int(cellview.frame.size.height) //다음 CellView의 위치
            cellview.addSubview(textview)
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width-1, height: max(CGFloat(inypos),scrollView.frame.height+1))
        scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidLoad() {
        print("viewDidload")
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got messages"), object: nil)
        FirebaseModel().getMessages()
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

