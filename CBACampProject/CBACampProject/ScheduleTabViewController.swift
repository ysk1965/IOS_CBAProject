//
//  ScheduleTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit

class ScheduleTabViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var Hamberger: UIButton!
    @IBAction func HambergerAction(_ sender: Any) {
        Hamberger.popIn(fromScale: 1.5, duration: 2, delay: 0)
    }
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var imageView: UIImageView!
    var image : UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SegueToSideMenu"{
            if let navController = segue.destination as? UINavigationController{
                if let SideMenuController = navController.topViewController as?
                    SideBarViewController {
                    SideMenuController.Check = true
                    SideMenuController.SelectMenu = false
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = UIViewContentMode.scaleAspectFit

        FirebaseModel().downloadImage(name: "timetable.png", imageView: imageView)
        
        imageView.frame = CGRect(origin: CGPoint(x:0, y:0), size: (self.view.frame.size))
        imageView.frame.size.height = imageView.frame.size.height - 100
        ScrollView.addSubview(imageView)
        
        ScrollView.contentSize = (imageView.frame.size)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapToZoom))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        ScrollView.addGestureRecognizer(doubleTap)
        
        /*
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScheduleTabViewController.scrollViewDoubleTapped(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        ScrollView.addGestureRecognizer(doubleTapRecognizer)
        
        
        let scrollViewFrame = ScrollView.frame
        let scaleWidth = scrollViewFrame.size.width / ScrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / ScrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        ScrollView.minimumZoomScale = minScale
        
        ScrollView.maximumZoomScale = 1.0
        ScrollView.zoomScale = minScale
        
        centerScrollViewContents()
        */
        
        //let pinchRecogniezer = UIPinchGestureRecognizer(target: self, action : #selector(pinchAction(_ :)))
        
        //ScrollView.addGestureRecognizer(pinchRecogniezer)
        
        centerScrollViewContents()
        // Do any additional setup after loading the view.
        
    }
    
    @objc func tapToZoom(_ gestureRecognizer: UIGestureRecognizer) {
        // 더블탭이 인식되면 호출된다.
        // 현재 줌 비율에 따라서
        switch ScrollView.zoomScale {
        case (ScrollView.minimumZoomScale..<1.0): // 축소된 상태인 경우
            ScrollView.setZoomScale(1.0, animated: true)
        case (1.0..<ScrollView.maximumZoomScale): // 확대된 상태인 경우
            ScrollView.setZoomScale(1.0, animated: true)
        default: // 최대 크기인 경우
            ScrollView.setZoomScale(ScrollView.maximumZoomScale, animated: true)
        }
    }
    
    func centerScrollViewContents(){
        let boundsSize = ScrollView.bounds.size
        var contensFrame = imageView.frame
        
        if contensFrame.size.width < boundsSize.width{
            contensFrame.origin.x = (boundsSize.width - contensFrame.size.width) / 2.0
        } else{
            contensFrame.origin.x = 0.0
        }
        if contensFrame.size.height < boundsSize.height {
            contensFrame.origin.y = (boundsSize.height - contensFrame.size.height) / 2.0
        } else{
            contensFrame.origin.y = 0.0
        }
        imageView.frame = contensFrame
    }
    
    @objc func scrollViewDoubleTapped(_ recognizer: UITapGestureRecognizer){
        let pointInView = recognizer.location(in: imageView)
        
        var newZoomScale = ScrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, ScrollView.maximumZoomScale)
        
        let scrollViewSize = ScrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w/2.0)
        let y = pointInView.y - (h/2.0)
        
        let rectToZoomTo = CGRect(x: x, y:y, width: w, height: h)
        
        ScrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    @objc func pinchAction(_ sender : UIPinchGestureRecognizer){
        ScrollView.transform = ScrollView.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
