//
//  CBAInfoTapViewController.swift
//  CBACampProject
//
//  Created by mac on 2018. 7. 24..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import MenuSlider
import Firebase
import ImageSlideshow
import Kingfisher
import SnapKit

class CBAInfoTabViewController: UIViewController, UIScrollViewDelegate, SideMenuDelegate {
    // move TabBar
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    // Arrange View Image
    @IBOutlet weak var ResizeNoti: UILabel!
    @IBOutlet weak var ResizeBanner: UIImageView!
    @IBOutlet weak var ResizeBottomView: UIView!
    @IBOutlet weak var titleNameImage: UIImageView!
    
    static var currentAgency : String!
    
    var firebaseModel: FirebaseModel = FirebaseModel()
    
    var Check : Bool?
    var userID : String?
    var viewX : CGFloat?
    var viewY : CGFloat?
    var viewH : CGFloat?
    var viewW : CGFloat?
    
    var menu: SideMenuViewController!
    
    // Optionally function onMenuClose(), fired when user closes menu
    func onMenuClose() {
        //MenuSetting()
        
        print("Action on Close Menu")
    }
    
    // Optionally function onMenuClose(), fired when user open menu
    func onMenuOpen() {
        SettingSidebar()
        print("Action on Open Menu")
    }
    
    @IBOutlet weak var Hamberger: UIButton!
    @IBAction func HambergerAction(_ sender: Any) {
        Hamberger.popIn(fromScale: 1.5, duration: 2, delay: 0)
        
        SettingSidebar()
        // call the menu method expand(*controller*) to open
        menu.expand(onController: self)
    }
    @IBOutlet weak var NoticeLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //parsing()
        /*
        
        if segue.identifier == "SegueToSideMenu"{
            if let navController = segue.destination as? UINavigationController{
                if let SideMenuController = navController.topViewController as?
                    SideBarViewController {
                    //SideMenuController.menu?.expand(onController: self)
                    SideMenuController.Check = true
                    SideMenuController.SelectMenu = false
                }
            }
        }
        */
    }
    
    @IBOutlet weak var CallOutlet: UIButton!
    @IBAction func CallAction(_ sender: Any) {
        CallOutlet.popIn(fromScale: 2, duration: 2, delay: 0)
        let urlString = "tel://" + "010-3397-4842"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.openURL(numberURL! as URL)
    }
    
    @IBOutlet weak var CenterCallOutlet: UIButton!
    @IBAction func CenterCallAction(_ sender: Any) {
        CenterCallOutlet.popIn(fromScale: 2, duration: 2, delay: 0)
        
        let urlString = "tel://" + "010-5025-4375"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.openURL(numberURL! as URL)
    }
    
    var url = URL(string:"http://cba.sungrak.or.kr/HomePage/Index")
    
    @IBOutlet weak var InstaOutlet: UIButton!
    @IBAction func InstagramAction(_ sender: Any) {
        InstaOutlet.popIn(fromScale: 20, duration: 4, delay: 0)
        url = URL(string:"https://www.instagram.com/cba.sungrak/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func viewload(_ notification: Notification){
        print("viewDidload_INFO")
        
        let count = FirebaseModel.messages.count
        
        for i in (0..<count).reversed(){
            if(FirebaseModel.messages[i].isStaff == "공지"){
                NoticeLabel.text = FirebaseModel.messages[i].text
                print("message : " + FirebaseModel.messages[i].text)
                break
            }
        }
    }
    
    func CallGetMyInfo(){
        // DataPassing
        print("parsing start")
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)!
            let urlObj = URL(string: url)
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    var myinfos = try decoder.decode(MyInfo.self, from: data)
                    
                    if(myinfos.age != nil){
                        MassageTabViewController.mainUser.setUser(age: myinfos.age!, campus: myinfos.campus!, mobile: myinfos.mobile!, name: myinfos.name!, gbsLevel: myinfos.gbsLevel!, grade: myinfos.grade!)
                    }
                    
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
        
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/getGBSInfo/" + (Auth.auth().currentUser?.uid)!
            let urlObj = URL(string: url)
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let myinfos = try decoder.decode(MyGBS.self, from: data)
                    
                    if(myinfos.gbsLevel != nil){
                        MassageTabViewController.mainGBS.setGBS(gbsLevel: myinfos.gbsLevel!, leader: myinfos.leader!, members: myinfos.members!)
                        MassageTabViewController.memberCount = myinfos.members!.count
                    }
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func SettingSidebar(){
        if(CBAInfoTabViewController.currentAgency == "몽산포"){
            
        }
        userID = Auth.auth().currentUser?.email
        //userID = "enter_maintanance@naver.com"
        
        // SideMenuItem Array
        var menuItemArray : Array<SideMenuItem> = []
        for n in AgencySingleton.shared.sidebar_setting{
            var tempMenu : SideMenuItem?
            if n.type == "image"{
                tempMenu = SideMenuItemFactory.make(title: n.iconName!){
                    FirebaseModel().ChangeImage(title: n.controlValue!)
                }
            } else if n.type == "segue"{
                tempMenu = SideMenuItemFactory.make(title: n.iconName!){
                    self.performSegue(withIdentifier: n.controlValue!, sender: nil)
                }
            }
            menuItemArray.append(tempMenu!)
        }
        
        /*
        // Creating a Menu Item with title string, with an action
        let menuItem0: SideMenuItem = SideMenuItemFactory.make(title: "GBS 확인"){
            if(!((Auth.auth().currentUser?.email) != nil)){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else{
                self.performSegue(withIdentifier: "SearchGBSSegue", sender: nil)
            }
        }
        let menuItem1: SideMenuItem = SideMenuItemFactory.make(title: "캠퍼스 모임장소") {
        }
        let menuItem2 = SideMenuItemFactory.make(title: "GBS장소") {
            FirebaseModel().ChangeImage(title: "campus_place")
        }
        let menuItem3 = SideMenuItemFactory.make(title: "또래별 강의") {
            FirebaseModel().ChangeImage(title: "room")
        }
        let menuItem4 = SideMenuItemFactory.make(title: "수련회장 배치도") {
            FirebaseModel().ChangeImage(title: "room")
        }
        let menuItem5 = SideMenuItemFactory.make(title: "식단 안내") {
            FirebaseModel().ChangeImage(title: "room")
        }
        let menuItem6 = SideMenuItemFactory.make(title: "식당/간식 봉사") {
            FirebaseModel().ChangeImage(title: "room")
        }
        let menuItem7 = SideMenuItemFactory.make(title: "청소구역") {
            FirebaseModel().ChangeImage(title: "room")
        }
        */
        
        /*
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
        */
        // SIDE BAR SETTING
        
        let BackImageView: UIImageView = UIImageView()
        BackImageView.image = UIImage(named: AgencySingleton.shared.sidebarBannerName!)
        
        //let menuheader = SideMenuHeaderFactory.make(title: "환언, 우리의 사명")
        let whiteLine = UILabel()
        whiteLine.frame = CGRect(x : viewX! + viewW!*0.035, y : viewY! + viewH!*0.03, width : viewW! * 0.58, height : viewH! * 0.001)
        whiteLine.backgroundColor = UIColor.black
        
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor.black
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.numberOfLines = 1
        //headerLabel.font = UIFont(name: "NotoSansUI-Regular.ttf", size: 5.0)
        headerLabel.adjustsFontSizeToFitWidth = true
        
        headerLabel.frame = CGRect(x : BackImageView.frame.origin.x, y : viewY!+BackImageView.frame.height * 0.2, width : BackImageView.frame.width * 0.88, height : viewH! * 0.13)
        
        let headerButton = UIButton()
        headerButton.setTitle(" ", for: .normal)
        headerButton.setTitleColor(UIColor.black, for: .normal)
        headerButton.backgroundColor = UIColor.white
        headerButton.frame = CGRect(x: BackImageView.frame.origin.x + BackImageView.frame.width * 0.075, y: BackImageView.frame.origin.y + BackImageView.frame.width * 0.075 , width: BackImageView.frame.width * 0.46, height: BackImageView.frame.height * 0.3)
        
        
        
        if((Auth.auth().currentUser) != nil){
            //print(Auth.auth().currentUser?.email!)
            headerButton.setTitle(" ", for: .normal)
            headerButton.setImage(UIImage(named: "19겨울_로그아웃글씨.png"), for: .normal)
            //print(MassageTabViewController.mainUser?.name)
            if(MassageTabViewController.mainUser.name == ""){
                headerLabel.text = "은혜 많이 받으세요 :)"
            }else{
                headerLabel.text = MassageTabViewController.mainUser.name + "(" + MassageTabViewController.mainUser.campus + ")님 환영합니다!"
            }
            headerButton.addTarget(self, action: #selector(self.Logout(_:)), for: .touchUpInside)
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
        BackImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //BackImageView.frame = CGRect(x : 0, y : 0, width : viewW! * viewH! / 10000 + viewH!/4, height : viewW! * 0.6 * 0.4)
        headerView.backgroundColor = UIColor.white
        
        //BackImageView.addSubview(headerLabel)
        headerView.addSubview(BackImageView)
        //headerView.addSubview(whiteLine)
        //headerView.addSubview(headerButton)
        
        let menuheader = SideMenuHeaderFactory.make(view: headerView)
        
        let footerView: UIImageView = UIImageView()
        footerView.backgroundColor = UIColor.white
        
        let whiteBottomLine = UILabel()
        whiteBottomLine.frame = CGRect(x : viewX! + 10, y : viewY! * -1 + 55, width : whiteLine.frame.width, height : viewH! * 0.001)
        whiteBottomLine.backgroundColor = UIColor.black
        
        footerView.addSubview(whiteBottomLine)
        
        let menufooter = SideMenuFooterFactory.make(view: footerView)
        
        let menuBuild = SideMenu(menuItems: menuItemArray, header: menuheader, footer: menufooter)
        
        self.menu = menuBuild.build()
        
        menu.delegate = self
    }
    
    @objc func loadVisiblePages(_ notification: Notification){
        slideshow.setImageInputs(FirebaseModel.imageKingfisher)
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageIndicator
        
        slideshow.pageIndicator = LabelPageIndicator()
        
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 20), vertical: .bottom)
        
        OpenImageView()
    }
    
    @objc func Logout(_ sender:UIButton){
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        
        SettingSidebar()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func LogIn(_ sender:UIButton){
        //self.menu.reduce(onController: self)
        
        print("In Login tab")
        
        if(!((Auth.auth().currentUser?.email) != nil)){
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        else{
            // 이럴 일 없음??
        }
    }
    
    @objc func GetYoutube(_ sender:UIButton){
        CloseImageView()
        url = URL(string:"https://www.youtube.com/channel/UCW6bF9L0ZK__Tlwl19B0FYQ/videos?view_as=subscriber")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func GetTimeTable(_ sender:UIButton){
        FirebaseModel().ChangeImage(title: "room")
    }
    
    @objc func GetGBS(_ sender:UIButton){
        CloseImageView()
        self.performSegue(withIdentifier: "SearchGBS", sender: nil)
    }
    
    @objc func GetQnA(_ sender:UIButton){
        CloseImageView()
        self.performSegue(withIdentifier: "QnaSegue", sender: nil)
    }
    
    @objc func GetNoti(_ sender:UIButton){
        CloseImageView()
        self.performSegue(withIdentifier: "QnaSegue", sender: nil)
    }
    
    @objc func GetCall(_ sender: Any) {
        let urlString = "tel://" + "010-3397-4842"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.open(numberURL! as URL)
        CloseImageView()
    }
    
    @objc func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    func OpenImageView(){
        slideshow.frame = CGRect(x: 0, y: viewW! * 0.2, width: viewW!, height: viewH! - viewW! * 0.4)
    }
    
    func CloseImageView(){
        slideshow.frame.size = CGSize(width: 0, height: 0)
    }
    
    
    
    
    
    
    /// Test용도입니다ㅏ...
    @objc func MoveSegue(_ sender:UIButton){
        CloseImageView()
        self.performSegue(withIdentifier: sender.currentTitle!, sender: nil)
    }
    
    @objc func ChangeImage(_ sender:UIButton){
        FirebaseModel().ChangeImage(title: sender.currentTitle!)
    }
    @objc func DoCall(_ sender:UIButton){
        let urlString = "tel://" + sender.currentTitle!
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.open(numberURL! as URL)
        CloseImageView()
    }
    @objc func MoveURL(_ sender:UIButton){
        CloseImageView()
        url = URL(string:sender.currentTitle!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func MakeBottomButton(button : Array<ButtonType>){
        /*
        let testButton = UIButton(frame: CGRect(x:0,y:0,width:viewW! * 0.2, height:viewW! * 0.2))
        testButton.setImage(UIImage(named: Button1), for: .normal)
        testButton.addTarget(self, action: #selector(self.GetQnA(_:)), for: .touchUpInside)
        ResizeBottomView.addSubview(testButton)
        
        let testButton2 = UIButton(frame: CGRect(x:viewW! * 0.2, y:0,width:viewW! * 0.2, height:viewW! * 0.2))
        testButton2.setImage(UIImage(named: Button2), for: .normal)
        testButton2.addTarget(self, action: #selector(self.GetCall(_:)), for: .touchUpInside)
        ResizeBottomView.addSubview(testButton2)
        
        let testButton3 = UIButton(frame: CGRect(x:viewW! * 0.4, y:0,width:viewW! * 0.2, height:viewW! * 0.2))
        testButton3.setImage(UIImage(named: Button3), for: .normal)
        testButton3.addTarget(self, action: #selector(self.GetTimeTable(_:)), for: .touchUpInside)
        ResizeBottomView.addSubview(testButton3)
        
        let testButton4 = UIButton(frame: CGRect(x:viewW! * 0.6, y:0,width:viewW! * 0.2, height:viewW! * 0.2))
        testButton4.setImage(UIImage(named: Button4), for: .normal)
        testButton4.addTarget(self, action: #selector(self.GetYoutube(_:)), for: .touchUpInside)
        ResizeBottomView.addSubview(testButton4)
        
        let testButton5 = UIButton(frame: CGRect(x:viewW! * 0.8, y:0,width:viewW! * 0.2, height:viewW! * 0.2))
        testButton5.setImage(UIImage(named: Button5), for: .normal)
        testButton5.addTarget(self, action: #selector(self.GetGBS(_:)), for: .touchUpInside)
        ResizeBottomView.addSubview(testButton5)
        */
        
        let arrayCnt : CGFloat = CGFloat(button.count)
        var loopcnt : CGFloat = 0
        for n in button {
            let customButton = UIButton(frame: CGRect(x:viewW! / arrayCnt * loopcnt,y:0,width:viewW! / arrayCnt, height:viewW! / arrayCnt))
            customButton.setImage(UIImage(named: n.iconName!),for: .normal)
            customButton.setTitle(n.controlValue, for: .normal)
            if n.type == "image"{
                customButton.addTarget(self, action: #selector(self.ChangeImage(_:)), for: .touchUpInside)
            } else if n.type == "segue"{
                customButton.addTarget(self, action: #selector(self.MoveSegue(_:)), for: .touchUpInside)
            } else if n.type == "call"{
                customButton.addTarget(self, action: #selector(self.DoCall(_:)), for: .touchUpInside)
            } else if n.type == "URL"{
                customButton.addTarget(self, action: #selector(self.MoveURL(_:)), for: .touchUpInside)
            }
            
            loopcnt += 1
            ResizeBottomView.addSubview(customButton)
        }
    }
    
    func ResizeView(buttonArray : Array<ButtonType>, Banner: String, TitleName: String){
        titleNameImage.translatesAutoresizingMaskIntoConstraints = false
        titleNameImage.image = UIImage(named: TitleName)
        titleNameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleNameImage.topAnchor.constraint(equalTo: view.topAnchor, constant: viewH!*0.055).isActive = true
        titleNameImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        titleNameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        ResizeBanner.image = UIImage(named: Banner)
        
        
        //slideshow
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.frame.size = CGSize(width: 0, height: 0)
        
        /*
        slideshow.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        slideshow.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        slideshow.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0).isActive = true
        slideshow.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        */
        
        ResizeBottomView.translatesAutoresizingMaskIntoConstraints = false
        ResizeBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ResizeBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ResizeBottomView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        ResizeBottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        MakeBottomButton(button: buttonArray)
        
        //ResizeNoti.sizeToFit()
        ResizeNoti.translatesAutoresizingMaskIntoConstraints = false
        ResizeNoti.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ResizeNoti.bottomAnchor.constraint(equalTo: ResizeBottomView.topAnchor).isActive = true
        ResizeNoti.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        ResizeNoti.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // Noti Button
        let notiButton = UIButton(frame: CGRect(x: 0, y: viewH! * 0.75 - viewW!/5, width: viewW!, height: viewH! * 0.25))
        //notiButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        notiButton.tintColor = UIColor.black
        notiButton.addTarget(self, action: #selector(self.GetNoti(_:)), for: .touchUpInside)
        view.addSubview(notiButton)
        
        ResizeBanner.translatesAutoresizingMaskIntoConstraints = false
        ResizeBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //ResizeBanner.bottomAnchor.constraint(equalTo: ResizeNoti.topAnchor, constant: viewH! * -0.02).isActive = true
        ResizeBanner.bottomAnchor.constraint(equalTo: ResizeNoti.topAnchor).isActive = true
        ResizeBanner.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        ResizeBanner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AgencySingleton.shared.~~~~
        // SingleTon선언
        // 이거 값 나중에는 데이터로 받아올 수 있도록 수정
        //ResizeView(Button1: "bottom_1.png", Button2: "bottom_2.png", Button3: "bottom_3.png", Button4: "bottom_4.png", Button5: "bottom_5.png", Banner: "몽산포_배너.png", TitleName: "몽산포.png")
        //ResizeView(Button1: "제목-없음-1.png", Button2: "CALL.png", Button3: "TIMETABLE.png", Button4: "ONAIR.png", Button5: "GBS.png", Banner: "배너.png", TitleName: "CBA.jpeg")
        
        //CBA Data
        var sidebarArray : Array<ButtonType> = []
        sidebarArray.removeAll()
        sidebarArray.append(ButtonType(type: "image",iconName: "또래별 강의", controlValue: "lecture"))
        sidebarArray.append(ButtonType(type: "image",iconName: "GBS 장소", controlValue: "gbs_place"))
        sidebarArray.append(ButtonType(type: "image",iconName: "식단", controlValue: "menu"))
        sidebarArray.append(ButtonType(type: "image",iconName: "식사/간식 봉사", controlValue: "mealwork"))
        sidebarArray.append(ButtonType(type: "image",iconName: "청소 구역", controlValue: "cleaning"))
        
        var bottomArray : Array<ButtonType> = []
        bottomArray.removeAll()
        bottomArray.append(ButtonType(type: "image",iconName: "bottom_1.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "segue",iconName: "bottom_2.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "image",iconName: "bottom_3.png", controlValue: "timetable"))
        bottomArray.append(ButtonType(type: "image",iconName: "bottom_4.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "image",iconName: "bottom_5.png", controlValue: "campus_place"))
        
        let currentAgency = AgencySingleton(
            AgencyTitle : "2019_CBA_SUMMER", // 2019_SR_SUMMER
            viewBannerName : "배너.png", // "몽산포_배너.png"
            sidebarBannerName : "CBA가로배너.png", // "몽산포_가로배너.png"
            topTagImageName : "CBA.jpeg", // "몽산포.png"
            sidebar_setting: sidebarArray, 
            bottombar_setting : bottomArray
        )
        
        viewX = self.view.frame.origin.x
        viewY = self.view.frame.origin.y
        viewW = self.view.frame.size.width
        viewH = self.view.frame.size.height
        
        // 2019_CBA_SUMMER
        // 2019_SR_SUMMER
        ResizeView(buttonArray : AgencySingleton.shared.bottombar_setting,
                   Banner: AgencySingleton.shared.viewBannerName!,
                   TitleName: AgencySingleton.shared.topTagImageName!
                  )
        SettingSidebar()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.loadVisiblePages),name: NSNotification.Name(rawValue: "change image"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "got messages"), object: nil)
        FirebaseModel().getMessages(messageTitle: "message")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
