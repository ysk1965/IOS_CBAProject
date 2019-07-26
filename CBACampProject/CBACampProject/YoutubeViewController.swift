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
    static var OpenYoutubeKey = ""
    static var OpenYoutubeValue = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    @IBAction func BackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @objc func ResizeView(_ notification: Notification){
        if(YoutubeViewController.OpenYoutubeValue == "c1"){
            youtubeView.load(withVideoId: FirebaseModel.youtubeURL[1])
            print(FirebaseModel.youtubeURL[1])
        } else{
            youtubeView.load(withVideoId: FirebaseModel.youtubeURL[2])
            print(FirebaseModel.youtubeURL[2])
        }
        youtubeView.fadeIn(duration: 2, delay: 0.5)
        youtubeView.frame = CGRect(x:0, y:0, width: Int(self.view.frame.width), height : Int(self.view.frame.height * 0.33))
        imageSlideShow.slideIn(from:.right, delay:0.5)
        imageSlideShow.frame = CGRect(x:0, y: Int(self.view.frame.height * 0.33), width : Int(self.view.frame.width), height : Int(self.view.frame.height * 0.67))
        //imageSlideShow.backgroundColor = UIColor.gray
        imageSlideShow.autoresizesSubviews = false
        imageSlideShow.setImageInputs(FirebaseModel.youtubeImage)
        //imageSlideShow.frame = CGRect(x:0, y:0, width:, height: 1000)
        
        imageSlideShow.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageSlideShow.circular = true
        var mainView = UIImageView()
        self.view.addSubview(mainView)
        mainView.image = UIImage(named : "몽산포_배경.png")
        mainView.alpha = 0.3
        mainView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view.frame.width * 1.777)
            make.width.width.equalTo(self.view.frame.width)
            make.centerX.equalTo(self.view!)
            make.bottom.equalTo(self.view)
        }
    }
    
    @objc func didTap() {
        imageSlideShow.presentFullScreenController(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseModel().YoutubeImage(title: YoutubeViewController.OpenYoutubeValue)
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.black
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageIndicator = pageIndicator
        
        //slideshow.pageIndicator = LabelPageIndicator()
        
        imageSlideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "set image"), object: nil)
        
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
