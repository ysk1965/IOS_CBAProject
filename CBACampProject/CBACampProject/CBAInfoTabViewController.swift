//
//  CBAInfoTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import MenuSlider
import Firebase

class CBAInfoTabViewController: UIViewController {
    
    @IBOutlet weak var Hamberger: UIButton!
    @IBAction func HambergerAction(_ sender: Any) {
        Hamberger.popIn(fromScale: 1.5, duration: 2, delay: 0)
    }
    @IBOutlet weak var NoticeLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SegueToSideMenu"{
            print("1.여기는?")
            if let navController = segue.destination as? UINavigationController{
                if let SideMenuController = navController.topViewController as?
                    SideBarViewController {
                    //SideMenuController.menu?.expand(onController: self)
                    SideMenuController.Check = true
                    SideMenuController.SelectMenu = false
                }
            }
        }
    }
    
    @IBOutlet weak var CallOutlet: UIButton!
    @IBAction func CallAction(_ sender: Any) {
        CallOutlet.popIn(fromScale: 2, duration: 2, delay: 0)
        let urlString = "tel://" + "010-3397-4842"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.openURL(numberURL! as URL)
    }
    
    @IBOutlet weak var CenterCallOutlet: UIButton!
    @IBAction func CenterCallAction(_ sender: Any) {
        CenterCallOutlet.popIn(fromScale: 2, duration: 2, delay: 0)
        
        let urlString = "tel://" + "010-5025-4375"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.openURL(numberURL! as URL)
    }
    
    var url = URL(string:"http://cba.sungrak.or.kr/HomePage/Index")
    
    @IBOutlet weak var WebOutlet: UIButton!
    @IBAction func SendWebAction(_ sender: Any) {
        WebOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        url = URL(string:"http://cba.sungrak.or.kr/HomePage/Index")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBOutlet weak var BlogOutlet: UIButton!
    @IBAction func LinkToBlogAction(_ sender: Any) {
        BlogOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        url = URL(string:"https://thebondofpeace.blog.me/221107817302")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBOutlet weak var YoutubeOutlet: UIButton!
    @IBAction func LinkToYoutubeAction(_ sender: Any) {
        YoutubeOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        url = URL(string:"https://www.youtube.com/channel/UCW6bF9L0ZK__Tlwl19B0FYQ")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBOutlet weak var InstaOutlet: UIButton!
    @IBAction func InstagramAction(_ sender: Any) {
        InstaOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        url = URL(string:"https://www.instagram.com/cba.sungrak/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func viewload(_ notification: Notification){
        print("viewDidload_INFO")
        
        let count = FirebaseModel.messages.count
        
        for i in (0..<count).reversed(){
            if(FirebaseModel.messages[i].isStaff == "공지"){
                NoticeLabel.text = FirebaseModel.messages[i].text
                print("message : " + FirebaseModel.messages[i].text)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got messages"), object: nil)
        FirebaseModel().getMessages()
        
        //TestOutlet.slideIn(from: .left, x: 2, y: 2, duration: 2, delay: 2)

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
