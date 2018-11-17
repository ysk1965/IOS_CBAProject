//
//  SideBarViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 26..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import MenuSlider

class SideBarViewController: UIViewController, UIScrollViewDelegate, SideMenuDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var BackOutlet: UIButton!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    var image : UIImage?
    var Check : Bool?
    
    
    // Implementing var menu, coming from SideMenuDelegate Protocol
    var menu: SideMenuViewController!
    @IBAction func Back(_ sender: Any) {
        BackOutlet.shake()
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var openMenuOutlet: UIButton!
    @IBAction func openMenu(_ sender: Any) {
        // call the menu method expand(*controller*) to open
        menu.expand(onController: self)
    }

    // Optionally function onMenuClose(), fired when user closes menu
    func onMenuClose() {
        print("Action on Close Menu")
        MainView.fadeIn(duration: 0.5, delay: 0.0)
        MainView.popIn()
        //MainView.(fromScale: 1, duration: 1, delay: 0.5)
    }
    
    // Optionally function onMenuClose(), fired when user open menu
    func onMenuOpen() {
        print("Action on Open Menu")
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
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for index in 0 ..< firstPage+1{
            purgePage(index)
        }
        for index in firstPage ... lastPage{
            loadPage(index)
        }
        for index in lastPage+1 ..< pageImages.count+1{
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        loadVisiblePages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //menu.expand(onController: self)
        
        // Creating a Menu Item with title string, with an action
        let menuItem1: SideMenuItem = SideMenuItemFactory.make(title: "캠퍼스 모임장소") {
            self.pageImages = [UIImage(named: "Test1.png")!,
                               UIImage(named: "Test2.png")!,
                               UIImage(named: "Test3.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        // Creating a Menu Item with title string, without an action
        let menuItem2 = SideMenuItemFactory.make(title: "GBS장소") {
            self.pageImages = [UIImage(named: "Test2.png")!,
                          UIImage(named: "Test3.png")!,
                          UIImage(named: "Test4.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        let menuItem3 = SideMenuItemFactory.make(title: "강의 안내") {
            self.pageImages = [UIImage(named: "Test3.png")!,
                               UIImage(named: "Test4.png")!,
                               UIImage(named: "Test1.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        let menuItem4 = SideMenuItemFactory.make(title: "숙소 안내") {
            self.pageImages = [UIImage(named: "Test4.png")!,
                               UIImage(named: "Test1.png")!,
                               UIImage(named: "Test2.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        let menuItem5 = SideMenuItemFactory.make(title: "식단 안내") {
            self.pageImages = [UIImage(named: "Test1.png")!,
                               UIImage(named: "Test2.png")!,
                               UIImage(named: "Test3.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        let menuItem6 = SideMenuItemFactory.make(title: "식당/간식 봉사") {
            self.pageImages = [UIImage(named: "Test2.png")!,
                               UIImage(named: "Test3.png")!,
                               UIImage(named: "Test4.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        let menuItem7 = SideMenuItemFactory.make(title: "청소구역") {
            self.pageImages = [UIImage(named: "Test3.png")!,
                               UIImage(named: "Test4.png")!,
                               UIImage(named: "Test1.png")!]
            let pageCount = self.pageImages.count
            
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = pageCount
            
            for _ in 0..<pageCount{
                self.pageViews.append(nil)
            }
            
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
            
            self.loadVisiblePages()
        }
        
        // Creating a Menu Header with title string
        let menuheader = SideMenuHeaderFactory.make(title: "환언, 우리들의 사명")
        
        let footerLabel = UILabel()
        footerLabel.text = "환언, 우리들의 사명"
        footerLabel.textAlignment = NSTextAlignment.center
        footerLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let footerView: UIView = UIView()
        footerLabel.frame = footerView.frame
        footerView.addSubview(footerLabel)
        footerView.backgroundColor = UIColor.black
        
        // Creating a Menu Footer with an UIView
        let menufooter = SideMenuFooterFactory.make(view: footerView)
        
        // Setting itens to the SideMenuViewController
        let menuBuild = SideMenu(menuItems: [menuItem1, menuItem2, menuItem3, menuItem4, menuItem5,menuItem6, menuItem7], header: menuheader,
                                 footer: menufooter)
        
        // Building the Menu SideMenuViewController
        self.menu = menuBuild.build()
        
        // Finally, setting self class for MenuController Delegate
        menu.delegate = self
        // Do any additional setup after loading the view.
        
        if Check == true{
            print("들어오냐???")
            menu.expand(onController: self)
            MainView.bounceIn(from: .right)
            Check = false
        }
        
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
