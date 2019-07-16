//
//  YoutubeViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 15..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import ImageSlideshow

class YoutubeViewController: UIViewController {
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    @IBAction func BackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @objc func ResizeView(_ notification: Notification){
        youtubeView.load(withVideoId: "PWYhzPSZSbE")
        youtubeView.frame = CGRect(x:0, y:0, width: Int(self.view.frame.width), height : Int(self.view.frame.height * 0.4))
        
        imageSlideShow.frame = CGRect(x:0, y: Int(self.view.frame.height * 0.4), width : Int(self.view.frame.width), height : Int(self.view.frame.height * 0.6))
        
        imageSlideShow.setImageInputs(FirebaseModel.imageKingfisher)
    }
    
    @objc func didTap() {
        imageSlideShow.presentFullScreenController(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseModel().setImageInputs(ChangeImage(title : "c1"))
        FirebaseModel().ChangeImage(title: "c1")
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "change image"), object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        //getVideo(vidioCode : "PWYhzPSZSbE")
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
