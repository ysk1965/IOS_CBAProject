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
    }

    // Optionally function onMenuClose(), fired when user closes menu
    func onMenuClose() {
        MenuSetting()
        print("Action on Close Menu")
        //MainView.fadeIn(duration: 0.5, delay: 0.0)
        //MainView.popIn()
        //MainView.(fromScale: 1, duration: 1, delay: 0.5)
    }
    
    // Optionally function onMenuClose(), fired when user open menu
    func onMenuOpen() {
        MenuSetting()
        print("Action on Open Menu")
    }
    
    func MenuSetting(){
        userID = Auth.auth().currentUser?.email
        //menu.expand(onController: self)
        //self.scrollView.frame.origin.y = 10
        self.scrollView.frame.size.width = self.view.frame.size.width
        self.scrollView.frame.size.height = self.view.frame.size.height - 90
        
        self.imageView.frame.origin = self.view.frame.origin
        self.imageView.frame.size.width = self.view.frame.size.width
        self.imageView.frame.size.height = self.view.frame.size.height - 90
        
        self.pageControl.frame.origin.y = self.view.frame.size.height - 40
        self.pageControl.frame.origin.x = self.view.frame.size.width / 2 - self.pageControl.frame.size.width / 2
        
        // Creating a Menu Item with title string, with an action
        let menuItem0: SideMenuItem = SideMenuItemFactory.make(title: "GBS 확인"){
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            
            if(!((Auth.auth().currentUser?.email) != nil)){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else{
                // 있을때는 어떻게
                
            }
        }
        
        
        let menuItem1: SideMenuItem = SideMenuItemFactory.make(title: "캠퍼스 모임장소") {
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
        let menuItem2 = SideMenuItemFactory.make(title: "GBS장소") {
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "gbs장소1.png")!,
                               UIImage(named: "gbs장소2.png")!,
                               UIImage(named: "gbs장소3.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = []
            self.loadVisiblePages()
        }
        
        let menuItem3 = SideMenuItemFactory.make(title: "또래별 강의") {
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "또래별강의.jpeg")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = []
            self.loadVisiblePages()
        }
        
        let menuItem4 = SideMenuItemFactory.make(title: "숙소 안내") {
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "숙소1.jpg")!,
                               UIImage(named: "숙소2.jpg")!,
                               UIImage(named: "숙소3.jpg")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = []
            self.loadVisiblePages()
        }
        
        let menuItem5 = SideMenuItemFactory.make(title: "식단 안내") {
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
        
        let menuItem6 = SideMenuItemFactory.make(title: "식당/간식 봉사") {
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
        
        let menuItem7 = SideMenuItemFactory.make(title: "청소구역") {
            for view in self.pageViews {
                view?.removeFromSuperview()
            }
            self.pageViews = []
            self.pageImages = [UIImage(named: "청소구역.jpeg")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.downloadImageNames = []
            self.loadVisiblePages()
        }
        
        // Creating a Menu Header with title string
        //let menuheader = SideMenuHeaderFactory.make(title: "환언, 우리의 사명")
        let headerButton = UIButton()
        headerButton.setTitle("LogOut", for: .normal)
        headerButton.setTitleColor(UIColor.blue, for: .normal)
        headerButton.backgroundColor = UIColor.black
        headerButton.frame = CGRect(x: 200, y: 100, width: 50, height: 30)
        headerButton.addTarget(self, action: #selector(self.Logout(_:)), for: .touchUpInside)
        
        let headerLabel = UILabel()
        if((Auth.auth().currentUser) != nil){
            headerLabel.text = Auth.auth().currentUser?.email
        } else{
            headerLabel.text = "로그인이 필요합니다."
        }
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.brown
        
        headerView.addSubview(headerLabel)
        if((Auth.auth().currentUser) != nil){
            headerView.addSubview(headerButton)
        }
        
        
        //headerView.tintColor = UIColor.blue
        
        
        // Creating a Menu Footer with an UIView
        let menuheader = SideMenuHeaderFactory.make(view: headerView)
        
        
        // Creating a Menu Header with title string
        
        let footerLabel = UILabel()
        footerLabel.text = "환언, 우리의 사명"
        footerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        footerLabel.textColor = UIColor.white
        footerLabel.textAlignment = NSTextAlignment.center
        footerLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let footerView: UIImageView = UIImageView()
        footerLabel.frame = footerView.frame
        footerView.addSubview(footerLabel)
        //footerView.backgroundColor = UIColor.gray
        footerView.image = UIImage(named: "Main.jpg")
        
        // Creating a Menu Footer with an UIView
        let menufooter = SideMenuFooterFactory.make(view: footerView)
        
        // Setting itens to the SideMenuViewController
        let menuBuild = SideMenu(menuItems: [menuItem0 ,menuItem1, menuItem2, menuItem3, menuItem4, menuItem5,menuItem6, menuItem7], header: menuheader,
                             footer: menufooter)
        
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
        
        MenuSetting()
        
        if Check == true{
            print("GET IN")
            menu.expand(onController: self)
            MainView.bounceIn(from: .right)
            Check = false
        }
    }
    
    @objc func Logout(_ sender:UIButton){
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        
        MenuSetting()
        
        dismiss(animated: true, completion: nil)
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
