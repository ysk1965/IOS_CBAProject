//
//  ImageViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 13..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import ImageSlideshow

class ImageViewController: UIViewController {
    @IBOutlet weak var Slideshow: ImageSlideshow!
    
    @IBAction func BackImage(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func ResizeView(){
        let mainView = UIImageView()
        
        self.view.addSubview(mainView)
        mainView.image = UIImage(named : "몽산포_배경.png")
        mainView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view.frame.width * 1.777)
            make.width.width.equalTo(self.view.frame.width)
            make.centerX.equalTo(self.view!)
            make.bottom.equalTo(self.view)
        }
        
        Slideshow.setImageInputs(FirebaseModel.noticeImage)
    }
    
    
    @objc func didTap() {
        Slideshow.presentFullScreenController(from: self)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        Slideshow.addGestureRecognizer(gestureRecognizer)
        
        FirebaseModel().GetNoticeImageInfo(title : NoticeViewController.OpenStringKey)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "set image"), object: nil)

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
