//
//  SideBarViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 26..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import MenuSlider
import FirebaseAuth

class SideBarViewController: UIViewController, UIScrollViewDelegate, SideMenuDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var BackOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var pageImages: [UIImage] = []
    var downloadImageNames: [String] = []
    var pageViews: [UIImageView?] = []
    var firebaseModel: FirebaseModel = FirebaseModel()
    
    var image : UIImage?
    var Check : Bool?
    var userID : String?
    var viewX : CGFloat?
    var viewY : CGFloat?
    var viewH : CGFloat?
    var viewW : CGFloat?
    
    var SelectMenu : Bool?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "UnwindToSegue"{
        }
    }
    
    @IBAction func BackScreenAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // Implementing var menu, coming from SideMenuDelegate Protocol
    var menu: SideMenuViewController!
    @IBAction func Back(_ sender: Any) {
        BackOutlet.shake()
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var openMenuOutlet: UIButton!
    @IBAction func openMenu(_ sender: Any) {
        MenuSetting()
        // call the menu method expand(*controller*) to open
        menu.expand(onController: self)
        SelectMenu = false
    }
    
    // Optionally function onMenuClose(), fired when user closes menu
    func onMenuClose() {
        MenuSetting()
        if(SelectMenu == false){
            dismiss(animated: true)
        }
        SelectMenu = false
        print("Action on Close Menu")
    }
    
    // Optionally function onMenuClose(), fired when user open menu
    func onMenuOpen() {
        MenuSetting()
        print("Action on Open Menu")
    }
    
    func MenuSetting(){
        userID = Auth.auth().currentUser?.email
        //userID = "enter_maintanance@naver.com"
        
        self.scrollView.frame.size.width = self.view.frame.size.width
        self.scrollView.frame.size.height = self.view.frame.size.height - 90
        
        self.imageView.frame.origin = self.view.frame.origin
        self.imageView.frame.size.width = self.view.frame.size.width
        self.imageView.frame.size.height = self.view.frame.size.height - 90
        
        self.pageControl.frame.origin.y = self.view.frame.size.height - 40
        self.pageControl.frame.origin.x = self.view.frame.size.width / 2 - self.pageControl.frame.size.width / 2
        
        // Creating a Menu Item with title string, with an action
        let menuItem0: SideMenuItem = SideMenuItemFactory.make(title: "  GBS 확인"){
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            
            if(!((Auth.auth().currentUser?.email) != nil)){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else{
                self.performSegue(withIdentifier: "SearchGBSSegue", sender: nil)
            }
        }
        
        
        let menuItem1: SideMenuItem = SideMenuItemFactory.make(title: "  캠퍼스 모임장소") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            
            //self.downloadImageNames = ["campus_place1.png","campus_place2.png","campus_place3.png"]
            self.downloadImageNames = ["campus_place1.png","campus_place2.png","campus_place3.png"]
            self.loadVisiblePages()
        }
        
        // Creating a Menu Item with title string, without an action
        let menuItem2 = SideMenuItemFactory.make(title: "  GBS장소") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["gbs_place1.png", "gbs_place2.png", "gbs_place3.png", "gbs_place4.png"]
            self.loadVisiblePages()
        }
        
        let menuItem3 = SideMenuItemFactory.make(title: "  또래별 강의") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["lecture.png"]
            self.loadVisiblePages()
        }
        
        let menuItem4 = SideMenuItemFactory.make(title: "  수련회장 배치도") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "이미지준비중.png")!,
                               UIImage(named: "19겨울_5층배치도.png")!,
                               UIImage(named: "19겨울_별관배치도.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["room1.png", "room2.png", "room3.png", "room4.png"]
            self.loadVisiblePages()
        }
        
        let menuItem5 = SideMenuItemFactory.make(title: "  식단 안내") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["menu.png"]
            self.loadVisiblePages()
        }
        
        let menuItem6 = SideMenuItemFactory.make(title: "  식당/간식 봉사") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["mealwork.png"]
            self.loadVisiblePages()
        }
        
        let menuItem7 = SideMenuItemFactory.make(title: "  청소구역") {
            self.SelectMenu = true;
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "이미지준비중.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = ["cleaning.png"]
            self.loadVisiblePages()
        }
        
        let menuItem8 = SideMenuItemFactory.make(title: "  출석체크") {
            self.SelectMenu = true;
            MassageTabViewController.mainUser.grade = "MISSION" // 임시
            
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            
            if(!((Auth.auth().currentUser?.email) != nil)){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else{
                
                if (MassageTabViewController.mainUser.grade == "LEADER" ||
                    MassageTabViewController.mainUser.grade == "MISSION"){
                    self.performSegue(withIdentifier: "CheckGBSSegue", sender: nil)
                }
                else {
                    debugPrint("grade : " + MassageTabViewController.mainUser.grade)
                }
                
            }
        }
        
        // Creating a Menu Header with title string
        //let menuheader = SideMenuHeaderFactory.make(title: "환언, 우리의 사명")
        let whiteLine = UILabel()
        whiteLine.frame = CGRect(x : viewX! + viewW!*0.035, y : viewY! + viewH!*0.04, width : viewW! * 0.59, height : viewH! * 0.001)
        whiteLine.backgroundColor = UIColor.white
        
        let BackImageView: UIImageView = UIImageView()
        BackImageView.image = UIImage(named: "19겨울_로그인상자.png")
        BackImageView.frame = CGRect(x : whiteLine.frame.origin.x, y : whiteLine.frame.origin.y + whiteLine.frame.origin.y/5, width : whiteLine.frame.width, height : viewH! * 0.16)
        
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor.white
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.numberOfLines = 1
        //headerLabel.font = UIFont(name: "NotoSansUI-Regular.ttf", size: 5.0)
        headerLabel.adjustsFontSizeToFitWidth = true
        
        headerLabel.frame = CGRect(x : BackImageView.frame.origin.x, y : viewY!+BackImageView.frame.height * 0.3, width : BackImageView.frame.width * 0.88, height : viewH! * 0.13)
        
        let headerButton = UIButton()
        headerButton.setTitle(" ", for: .normal)
        headerButton.setTitleColor(UIColor.black, for: .normal)
        headerButton.backgroundColor = UIColor.black
        headerButton.frame = CGRect(x: BackImageView.frame.origin.x + BackImageView.frame.width * 0.075, y: BackImageView.frame.origin.y + BackImageView.frame.width * 0.075 , width: BackImageView.frame.width * 0.46, height: BackImageView.frame.height * 0.3)
        
        
        if((Auth.auth().currentUser) != nil){
            headerButton.setTitle(" ", for: .normal)
            headerButton.setImage(UIImage(named: "19겨울_로그아웃글씨.png"), for: .normal)
            //print(MassageTabViewController.mainUser?.name)
            if(MassageTabViewController.mainUser.name == ""){
                headerLabel.text = "은혜 많이 받으세요 :)"
            }else{
            headerLabel.text = MassageTabViewController.mainUser.name + "(" + MassageTabViewController.mainUser.campus + ")님 환영합니다!"
            headerButton.addTarget(self, action: #selector(self.Logout(_:)), for: .touchUpInside)
            }
        } else{
            headerButton.setTitle(" ", for: .normal)
            headerButton.setImage(UIImage(named: "19겨울_로그인텍스트.png"), for: .normal)
            
            headerLabel.text = "로그인 해주세요."
            headerButton.addTarget(self, action: #selector(self.LogIn(_:)), for: .touchUpInside)
        }
        
        //headerLabel.backgroundColor = UIColor.darkGray
        headerLabel.textAlignment = NSTextAlignment.left
        //headerLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.black
        
        BackImageView.addSubview(headerLabel)
        
        headerView.addSubview(BackImageView)
        headerView.addSubview(whiteLine)
        headerView.addSubview(headerButton)
        
        // Creating a Menu Footer with an UIView
        let menuheader = SideMenuHeaderFactory.make(view: headerView)
        
        
        // Creating a Menu Header with title string
        //let footerLabel = UILabel()
        //footerLabel.backgroundColor = UIColor.white
        //footerLabel.text = "환언, 우리의 사명"
        //footerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //footerLabel.textColor = UIColor.white
        //footerLabel.textAlignment = NSTextAlignment.center
        //footerLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let footerView: UIImageView = UIImageView()
        footerView.backgroundColor = UIColor.black
        
        let whiteBottomLine = UILabel()
        whiteBottomLine.frame = CGRect(x : viewX! + 10, y : viewY! * -1 + 55, width : whiteLine.frame.width, height : viewH! * 0.001)
        whiteBottomLine.backgroundColor = UIColor.white
        
        footerView.addSubview(whiteBottomLine)
        
        // Creating a Menu Footer with an UIView
        let menufooter = SideMenuFooterFactory.make(view: footerView)
        
        // Setting itens to the SideMenuViewController
        let menuBuild = SideMenu(menuItems: [menuItem8, menuItem0 ,menuItem1, menuItem2, menuItem3, menuItem4, menuItem5,menuItem6, menuItem7], header: menuheader, footer: menufooter)
        
        // Building the Menu SideMenuViewController
        self.menu = menuBuild.build()
        
        // Finally, setting self class for MenuController Delegate
        menu.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func loadPage(_ page: Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        
        if pageViews[page] != nil {
            // x
        } else{
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            
            let backImage = UIImageView()
            backImage.image = UIImage(named : "19겨울_메세지배경.png")
            backImage.frame = frame
           scrollView.addSubview(backImage)
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            
            if (downloadImageNames.count > page) {
                print("downloading!", downloadImageNames.count, "/", page)
                firebaseModel.downloadImage(name: downloadImageNames[page], imageView: newPageView)
            }
            
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(_ page: Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        if let pageView = pageViews[page]{
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages(){
        self.imageView.isHidden = true
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        pageControl.currentPage = page
        
        let firstPage = 0
        let lastPage = pageImages.count - 1
        
        
        for i in 0 ..< firstPage+1{
            purgePage(i)
            print("purging...", i)
        }
        for i in firstPage ... lastPage{
            loadPage(i)
            print("loading...",i)
        }
        /*
        for i in lastPage+1 ..< pageImages.count+1{
            purgePage(i)
        }
        */
        for i in stride(from: lastPage+1  , to: pageImages.count+1, by: 1)
        {
            purgePage(i)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadVisiblePages()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewX = self.view.frame.origin.x
        viewY = self.view.frame.origin.y
        viewW = self.view.frame.size.width
        viewH = self.view.frame.size.height
        
        MenuSetting()
        
        if Check == true{
            print("GET IN")
            menu.expand(onController: self)
            MainView.bounceIn(from: .right)
            Check = false
        }
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        view.addGestureRecognizer(pinch)
        
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        guard sender.view != nil else { return }
        
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }
    }
    
    @IBAction func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        imageView.transform =
            CGAffineTransform.init(scaleX: scale, y: scale)
        
        sender.scale = 1
    }
    
    //@objc func handleTap
    
    @objc func Logout(_ sender:UIButton){
        
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        
        MenuSetting()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func LogIn(_ sender:UIButton){
        
        self.SelectMenu = true;
        //self.menu.reduce(onController: self)
        
        print("In Login tab")
        
        if(!((Auth.auth().currentUser?.email) != nil)){
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        else{
            // 있을때는 어떻게
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
