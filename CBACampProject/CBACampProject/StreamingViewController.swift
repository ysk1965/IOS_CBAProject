//
//  StreamingViewController.swift
//  CBACampProject
//
//  Created by JUDY on 07/08/2019.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class StreamingViewController: UIViewController {
    @IBAction func BackAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var YoutubeView: WKYTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YoutubeView.load(withVideoId: FirebaseModel.youtubeURL[2])

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
