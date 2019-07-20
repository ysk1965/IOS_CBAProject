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
import RealmSwift
import Realm

class MyData: Object{
    @objc dynamic var userUid : String = ""
    @objc dynamic var currentAgent : String = ""
}

class CBAInfoTabViewController: UIViewController, UIScrollViewDelegate, SideMenuDelegate {
    @IBOutlet weak var notiButton: UIButton!
    // move TabBar
    @IBOutlet weak var loadingPage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var hambergerButton: UIButton!
    
    // Arrange View Image
    @IBOutlet weak var ResizeNoti: UILabel!
    @IBOutlet weak var ResizeBanner: UIImageView!
    @IBOutlet weak var ResizeBottomView: UIView!
    @IBOutlet weak var TopImageButtonOutlet: UIButton!
    @IBAction func TopImageButton(_ sender: Any) {
        CloseImageView()
    }
    
    static var isNotiMessage = false
    
    let realm = try! Realm()
    
    var firebaseModel: FirebaseModel = FirebaseModel()
    
    var Check : Bool?
    var userID : String?
    var viewX : CGFloat?
    var viewY : CGFloat?
    var viewH : CGFloat?
    var viewW : CGFloat?
    
    static var ScreenWidth : CGFloat?
    static var ScreenHeight : CGFloat?
    
    func addMyData(uid: String, agent : String) {
        let myData = MyData()
        
        myData.userUid = uid
        myData.currentAgent = agent
        
        try! realm.write {
            realm.add(myData)
        }
        print("success")
    }
    
    var menu: SideMenuViewController!
    
    // Optionally function onMenuClose(), fired when user closes menu
    func onMenuClose() {
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
    
    var url = URL(string:"http://cba.sungrak.or.kr/HomePage/Index")
    
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
    
    func SettingSidebar(){
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        self.performSegue(withIdentifier: n.controlValue!, sender: nil)
                    }
                }
            } else if n.type == "info"{
                tempMenu = SideMenuItemFactory.make(title: n.iconName!){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        NoticeViewController.OpenStringValue = n.controlValue!
                        
                        self.performSegue(withIdentifier: "infoSegue", sender: nil)
                    }
                }
            } else if n.type == "youtube"{
                tempMenu = SideMenuItemFactory.make(title: n.iconName!){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        YoutubeViewController.OpenYoutubeValue = n.controlValue!
                        
                        self.performSegue(withIdentifier: "youtubeSegue", sender: nil)
                    }
                }
            }
            menuItemArray.append(tempMenu!)
        }
        
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
        
        
        //BackImageView.frame = CGRect(x:0, y:30, width: 267, height: 30)
        BackImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        var testLabel = UITextView()
        testLabel.textColor = UIColor.darkGray
        //testLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        testLabel.frame = CGRect(x:5,y:viewH! * 0.12, width:viewW! * 0.6, height: viewH! * 0.2)
        testLabel.font = UIFont(name: "NotoSansUI-Regular"
            , size: viewH!)
        testLabel.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0)
        testLabel.text = """
        예수 그리스도는
        어제나 오늘이나 동일하시다
                                    (히13:8)
        """
        //testLabel.sizeToFit()
        BackImageView.addSubview(testLabel)
        
        let ImageButton = UIButton()
        //ImageButton.setTitle("QnaSegue", for: .normal)
        ImageButton.setTitleColor(UIColor.black, for: .normal)
        ImageButton.backgroundColor = UIColor.white
        ImageButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ImageButton.addTarget(self, action: #selector(self.SetPopup(_:)), for: .touchUpInside)
        headerView.addSubview(ImageButton)
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
        
        print(headerView.frame)
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
    
    func RenewRealmData(title : String){
        try! realm.write {
            realm.deleteAll()
        }
        addMyData(uid: AgencySingleton.shared.realmUid!, agent: title)
        AgencySingleton.shared.realmAgent = title
    }
    
    @objc func SetCBA(_ sender:UIButton){
        CloseImageView()
        RenewRealmData(title: "CBA")
        AgencySingleton.shared.SetCBAAgency()
        main_popupView.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load main view"), object: self)
    }
    
    @objc func SetMonsanpo(_ sender:UIButton){
        CloseImageView()
        RenewRealmData(title: "MONGSANPO")
        AgencySingleton.shared.SetMongsanpoAgency()
        main_popupView.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load main view"), object: self)
    }
    
    @objc func GetNoti(_ sender:UIButton){
        CloseImageView()
        CBAInfoTabViewController.isNotiMessage = true
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
        slideshow.circular = true
        slideshow.frame = CGRect(x: 0, y: viewW! * 0.2, width: viewW!, height: viewH! - viewW! * 0.4)
        notiButton.frame.size = CGSize(width: 0, height: 0)
    }
    
    func CloseImageView(){
        slideshow.frame.size = CGSize(width: 0, height: 0)
        notiButton.frame = CGRect(x: 0, y: viewH! * 0.75 - viewW!/5, width: viewW!, height: viewH! * 0.25)
    }
    
    lazy var main_popupView = UIView()
    lazy var inner_popupView = UIView()
    lazy var popupView_toptext = UILabel()
    lazy var popupView_blackline = UILabel()
    lazy var popupView_cbaButton = UIButton()
    lazy var popupView_mongsanpoButton = UIButton()
    lazy var popupView_bottomtext = UILabel()
    
    func SetPopupView(){
        self.view.addSubview(main_popupView)
        main_popupView.backgroundColor = UIColor.black
        main_popupView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(380)
            make.width.width.equalTo(310)
            make.center.equalTo(self.view)
        }
        
        main_popupView.addSubview(inner_popupView)
        inner_popupView.backgroundColor = UIColor.white
        inner_popupView.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(370)
            make.width.width.equalTo(300)
            make.center.equalTo(self.view)
        }
        
        main_popupView.addSubview(popupView_toptext)
        popupView_toptext.text = "수련회를 선택해주세요"
        popupView_toptext.backgroundColor = UIColor.white
        popupView_toptext.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(50)
            make.width.width.equalTo(300)
            make.centerX.equalTo(main_popupView)
            make.top.equalTo(main_popupView).offset(30)
        }
        popupView_toptext.font = UIFont(name: "NotoSansUI-Regular"
            , size: 20)
        popupView_toptext.textAlignment = NSTextAlignment.center
        popupView_toptext.adjustsFontSizeToFitWidth = true
        
        main_popupView.addSubview(popupView_blackline)
        popupView_blackline.backgroundColor = UIColor.black
        popupView_blackline.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(1)
            make.width.width.equalTo(50)
            make.centerX.equalTo(main_popupView)
            make.bottom.equalTo(popupView_toptext).offset(0)
        }
        
        main_popupView.addSubview(popupView_cbaButton)
        popupView_cbaButton.slideOut()
        popupView_cbaButton.backgroundColor = UIColor.white
        popupView_cbaButton.addTarget(self, action: #selector(self.SetCBA(_:)), for: .touchUpInside)
        popupView_cbaButton.setImage(UIImage(named: "CBA선택.png"), for: UIControl.State.normal)
        popupView_cbaButton.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(80)
            make.width.width.equalTo(270)
            make.centerX.equalTo(main_popupView)
            make.bottom.equalTo(popupView_blackline).offset(100)
        }
        
        main_popupView.addSubview(popupView_mongsanpoButton)
        popupView_mongsanpoButton.slideOut()
        popupView_mongsanpoButton.backgroundColor = UIColor.white
        popupView_mongsanpoButton.addTarget(self, action: #selector(self.SetMonsanpo(_:)), for: .touchUpInside)
        popupView_mongsanpoButton.setImage(UIImage(named: "몽산포선택.png"), for: UIControl.State.normal)
        popupView_mongsanpoButton.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(80)
            make.width.width.equalTo(270)
            make.centerX.equalTo(main_popupView)
            make.bottom.equalTo(popupView_cbaButton).offset(80)
        }
        main_popupView.addSubview(popupView_bottomtext)
        popupView_bottomtext.backgroundColor = UIColor.white
        popupView_bottomtext.snp.makeConstraints { (make) -> Void in
            make.height.height.equalTo(12)
            make.width.width.equalTo(240)
            make.centerX.equalTo(main_popupView)
            make.bottom.equalTo(main_popupView).offset(-30)
        }
        popupView_bottomtext.text = "클릭하면 해당 페이지로 넘어갑니다"
        popupView_bottomtext.textAlignment = NSTextAlignment.center
        popupView_bottomtext.adjustsFontSizeToFitWidth = true
        
    }
    
    @objc func SetPopup(_ sender:UIButton){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
            self.menu.reduce(onController: self)
        }
        
        
        
        SetPopupView()
        
    }
    
    @objc func MoveSegue(_ sender:UIButton){
        CloseImageView()
        
        self.performSegue(withIdentifier: sender.currentTitle!, sender: nil)
    }
    
    @objc func InfoSegue(_ sender:UIButton){
        CloseImageView()
        
        NoticeViewController.OpenStringValue = sender.currentTitle!
        
        self.performSegue(withIdentifier: "infoSegue", sender: nil)
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
        UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func MakeBottomButton(button : Array<ButtonType>){
        for view in self.ResizeBottomView.subviews {
            view.removeFromSuperview()
        }
        
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
            } else if n.type == "url"{
                customButton.addTarget(self, action: #selector(self.MoveURL(_:)), for: .touchUpInside)
            } else if n.type == "info"{
                customButton.addTarget(self, action: #selector(self.InfoSegue(_:)), for: .touchUpInside)
            }
            
            loopcnt += 1
            ResizeBottomView.addSubview(customButton)
        }
    }
    
    lazy var titleNameButton = UIButton()
    @objc func ResizeView(_ notification: Notification){
        NoticeLabel.text = FirebaseModel.mainNotiMessages
        
        hambergerButton.translatesAutoresizingMaskIntoConstraints = false
        hambergerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 38).isActive = true
        hambergerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 13).isActive = true
        hambergerButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.085).isActive = true
        hambergerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.11).isActive = true
        
        TopImageButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        TopImageButtonOutlet.setImage(UIImage(named: AgencySingleton.shared.topTagImageName!), for: .normal)
        TopImageButtonOutlet.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        TopImageButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        TopImageButtonOutlet.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        TopImageButtonOutlet.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        ResizeBanner.image = UIImage(named: AgencySingleton.shared.viewBannerName!)
        
        
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
        
        MakeBottomButton(button: AgencySingleton.shared.bottombar_setting)
        
        //ResizeNoti.sizeToFit()
        ResizeNoti.translatesAutoresizingMaskIntoConstraints = false
        ResizeNoti.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ResizeNoti.bottomAnchor.constraint(equalTo: ResizeBottomView.topAnchor).isActive = true
        ResizeNoti.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        ResizeNoti.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // Noti Button
        notiButton.frame = CGRect(x: 0, y: viewH! * 0.75 - viewW!/5, width: viewW!, height: viewH! * 0.25)
        
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
        
        // 한번만 없애면 됨
        if(loadingPage != nil){
            loadingPage.removeFromSuperview()
        }
    }
    
    func SetRealmData(defaultAgent : String){
        let myData = realm.objects(MyData.self)
        let uuid = "IOS_" + UUID().uuidString
        
        if(myData.count == 0){
            addMyData(uid : uuid, agent : defaultAgent)
        }
        AgencySingleton.shared.realmUid = myData.first?.userUid
        AgencySingleton.shared.realmAgent = myData.first?.currentAgent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetNotificationCenter()
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
        bottomArray.append(ButtonType(type: "image",iconName: "제목-없음-1.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "segue",iconName: "CALL.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "image",iconName: "TIMETABLE.png", controlValue: "timetable"))
        bottomArray.append(ButtonType(type: "image",iconName: "ONAIR.png", controlValue: "campus_place"))
        bottomArray.append(ButtonType(type: "image",iconName: "GBS.png", controlValue: "campus_place"))
        
        
        let currentAgency = AgencySingleton(
            AgencyTitle : "2019_CBA_SUMMER", // 2019_SR_SUMMER
            viewBannerName : "배너.png", // "몽산포_배너.png"
            sidebarBannerName : "CBA가로배너.png", // "몽산포_가로배너.png"
            topTagImageName : "CBA.jpeg", // "몽산포.png"
            sidebar_setting: sidebarArray,
            bottombar_setting : bottomArray
        )
        
        // uuid, agent 생성
        SetRealmData(defaultAgent: "MONGSANPO");
        
        
        // CBAInfoTabViewController.currentAgency 요거 Realm에 넣어놔야 함. 그걸로 nil체크!
        if(AgencySingleton.shared.realmAgent != nil){
            if(AgencySingleton.shared.realmAgent == "CBA"){
                AgencySingleton.shared.SetCBAAgency()
            } else if (AgencySingleton.shared.realmAgent == "MONGSANPO"){
                AgencySingleton.shared.SetMongsanpoAgency()
            }
        }
        
        /*
         try! realm.write {
         realm.deleteAll()
         }
         */
        
        viewX = self.view.frame.origin.x
        viewY = self.view.frame.origin.y
        viewW = self.view.frame.size.width
        viewH = self.view.frame.size.height
        
        CBAInfoTabViewController.ScreenWidth = self.view.frame.size.width
        CBAInfoTabViewController.ScreenHeight = self.view.frame.size.height
        
        loadingPage.frame = CGRect(x:0, y:Int(Int(viewH!) - Int(viewW!) - Int(viewW! * 0.2) - Int(viewH! * 0.25)), width: Int(viewW!),  height:Int(viewW!))
        loadingPage.image = UIImage(named: AgencySingleton.shared.sidebarBannerName!)
        loadingPage.image = UIImage(named: AgencySingleton.shared.viewBannerName!)
        
        // 2019_CBA_SUMMER
        // 2019_SR_SUMMER
        SettingSidebar()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        // load main view!!
        FirebaseModel().FirstLoadView()
    }
    
    func SetNotificationCenter(){
        NotificationCenter.default.addObserver(self,selector: #selector(self.loadVisiblePages),name: NSNotification.Name(rawValue: "change image"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "load main view"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.ResizeView),name: NSNotification.Name(rawValue: "set youtube"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
