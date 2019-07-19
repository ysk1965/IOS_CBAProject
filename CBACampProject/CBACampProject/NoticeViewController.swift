//
//  NoticeViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 12..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import Foundation

class NoticeViewController: UIViewController, UIScrollViewDelegate {
    static var OpenStringKey = ""
    static var OpenStringValue = ""
    
    lazy var backgroundImage = UIImageView()
    
    @IBAction func BackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func SetStringKey(_ sender:UIButton){
        NoticeViewController.OpenStringKey = sender.titleLabel!.text!
        self.performSegue(withIdentifier: "ImageSegue", sender: nil)
    }
    
    @objc func ResizeView(){
        self.view.addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: "몽산포_배경.png")
        backgroundImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view.frame.width * 1.777)
            make.width.width.equalTo(self.view.frame.width)
            make.centerX.equalTo(self.view!)
            make.bottom.equalTo(self.view)
        }
        
        var offset = view.self.frame.height / 17
        
        for n in FirebaseModel.noticeDictionary {
            offset += self.view.frame.height / 20 + 10
            
            let blackLabel = UILabel()
            
            self.view.addSubview(blackLabel)
            blackLabel.backgroundColor = UIColor.black
            blackLabel.textAlignment = NSTextAlignment.center
            blackLabel.adjustsFontSizeToFitWidth = true
            blackLabel.snp.makeConstraints { (make) -> Void in
                make.height.height.equalTo(self.view.frame.height / 23)
                make.width.width.equalTo(self.view.frame.width * 0.9 + 2)
                make.centerX.equalTo(backgroundImage)
                make.top.equalTo(self.view).offset(offset - 1)
            }
            
            let noticeButton = UIButton()
            
            self.view.addSubview(noticeButton)
            noticeButton.titleLabel!.text = n.value
            noticeButton.backgroundColor = UIColor.white
            noticeButton.titleLabel?.textAlignment = NSTextAlignment.center
            noticeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            noticeButton.addTarget(self, action: #selector(self.SetStringKey(_:)), for: .touchUpInside)
            noticeButton.snp.makeConstraints { (make) -> Void in
                make.height.height.equalTo(self.view.frame.height / 23 - 2)
                make.width.width.equalTo(self.view.frame.width * 0.9)
                make.centerX.equalTo(backgroundImage)
                make.top.equalTo(self.view).offset(offset)
            }
            
            let noticeLabel = UILabel()
            
            self.view.addSubview(noticeLabel)
            noticeLabel.text = n.key
            noticeLabel.textAlignment = NSTextAlignment.center
            noticeLabel.adjustsFontSizeToFitWidth = true
            noticeLabel.snp.makeConstraints { (make) -> Void in
                make.height.height.equalTo(self.view.frame.height / 23 - 2)
                make.width.width.equalTo(self.view.frame.width * 0.9)
                make.centerX.equalTo(backgroundImage)
                make.top.equalTo(self.view).offset(offset)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseModel().GetNoticeInfo(title: NoticeViewController.OpenStringValue)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "GetNoticeInfo"), object: nil)
        
        // Do any additional setup after loading the view.
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
