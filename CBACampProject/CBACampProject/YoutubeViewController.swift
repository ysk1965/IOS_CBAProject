//
//  YoutubeViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 15..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class YoutubeViewController: UIViewController {
    @IBOutlet weak var youtubeView: WKYTPlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubeView.load(withVideoId: "PWYhzPSZSbE")
        youtubeView.frame = CGRect(x:0,y:0,width:self.view.frame.width, self.view.frame.height * 0.3), height : Int(self.view.frame.height * 0.3))
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
