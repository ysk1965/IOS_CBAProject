//
//  SearchGBSViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 11..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

struct User {
    var name : String?
    var age : Int?
    var campus : String?
    var mobile : String?
}

class SearchGBSViewController: UIViewController, UIScrollViewDelegate {
    var gbsLevel : String?
    var leader : User?
    var member : [User]?
    var memberCnt : Int?
    @IBOutlet weak var leaderName: UILabel!
    @IBOutlet weak var leaderAge: UILabel!
    @IBOutlet weak var leaderCampus: UILabel!
    @IBOutlet weak var leaderMobile: UILabel!
    @IBOutlet weak var GBSLevelLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func Back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func viewload(_ notification: Notification) {
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        let scrollcontainerView = UIView(frame: scrollView.frame)
        scrollView.addSubview(scrollcontainerView)
        //scrollView.addSubview(buttonView)
        
        var inypos = 1
        let inxpos = 20
        let count = MassageTabViewController.memberCount
        
        leaderName.text = MassageTabViewController.mainGBS.leader?.name
        leaderAge.text = "\(MassageTabViewController.mainGBS.leader?.age ?? 0)"
        leaderCampus.text = MassageTabViewController.mainGBS.leader?.campus
        leaderMobile.text = MassageTabViewController.mainGBS.leader?.mobile
        
        GBSLevelLabel.text = MassageTabViewController.mainGBS.gbsLevel!
        
        
        
        for i in 0..<count {
            var nextypos = 0
            let cellview = UIView()
            cellview.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5).cgColor
            cellview.layer.borderWidth = 0
                
            
            cellview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
            cellview.frame = CGRect(x: 0, y: inypos, width : Int(scrollView.frame.width), height: 80)
            scrollView.addSubview(cellview)
            
            //profile image, rank name label, name label //////////////////////////////
            
            ///namelabel
            let namelabel = UILabel()
            namelabel.text = "• 이름 :" + MassageTabViewController.mainGBS.members![i].name!
            namelabel.font = UIFont(name: "NotoSansUI-Regular", size: 17.0)!
            namelabel.textColor = UIColor.black
            namelabel.sizeToFit()
            namelabel.frame.origin = CGPoint(x: 20, y: 18)
            cellview.addSubview(namelabel)
            
            ///agelabel
            let agelabel = UILabel()
            agelabel.text = "• 나이 :\(MassageTabViewController.mainGBS.members![i].age!)"
            agelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            agelabel.textColor = UIColor.black
            agelabel.sizeToFit()
            agelabel.frame.origin = CGPoint(x: 20, y: 41)
            cellview.addSubview(agelabel)
            
            ///campuslabel
            let campuslabel = UILabel()
            campuslabel.text = "• 캠퍼스 :\(MassageTabViewController.mainGBS.members![i].campus!)"
            campuslabel.font = UIFont(name: "NotoSans", size: 17.0)!
            campuslabel.textColor = UIColor.black
            campuslabel.sizeToFit()
            campuslabel.frame.origin = CGPoint(x: 20, y: 64)
            cellview.addSubview(campuslabel)
            
            ///mobilelabel
            let mobilelabel = UILabel()
            mobilelabel.text = "• 연락처 :\(MassageTabViewController.mainGBS.members![i].mobile!)"
            mobilelabel.font = UIFont(name: "NotoSans", size: 17.0)!
            mobilelabel.textColor = UIColor.black
            mobilelabel.sizeToFit()
            mobilelabel.frame.origin = CGPoint(x: 20, y: 87)
            cellview.addSubview(mobilelabel)
            
            //textview///////////////////////////////////////
            let textview = UITextView()
            textview.frame.origin = CGPoint(x:inxpos, y:nextypos)
            textview.frame.size = CGSize(width: Int(scrollView.frame.width) - inxpos * 2, height: 120)
            let contentSize = textview.sizeThatFits(textview.bounds.size)
            var frame = textview.frame
            frame.size.height = max(contentSize.height, 120)
            textview.frame = frame
            textview.isScrollEnabled = false
            textview.isEditable = false
            textview.isUserInteractionEnabled = true
            nextypos = Int(textview.frame.origin.y + textview.frame.size.height + 8)
            textview.backgroundColor = UIColor.init(white: 0, alpha: 0)
            
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
        super.viewDidLoad()
        
        if(MassageTabViewController.mainGBS.leader == nil){
            let blankImage = UIImageView()
            blankImage.image = UIImage(named: "준비중.png")
            self.view.addSubview(blankImage)
            blankImage.snp.makeConstraints { (make) -> Void in
                make.height.height.equalTo(self.view.frame.width * 8/6)
                make.width.width.equalTo(self.view.frame.width)
                make.center.equalTo(self.view)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got GBS"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got GBS"), object: self)
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
