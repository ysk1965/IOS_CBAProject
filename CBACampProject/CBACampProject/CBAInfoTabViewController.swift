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
    let backgroundView = UIImageView()
    
    static var isNotiMessage = false
    static var isSendNotiMessage = false // 공지 보내기 기능 on off
    
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
    
    //GBS & My Info
    static var mainUser = MainUser(memId: 0, campus: "", mobile: "", name: "", grade: "", retreatGbsInfo: nil, gbsInfo: nil)
    static var mainGBS = MainGBS(gbsLevel: "", leader: nil, members: nil)
    static var memberCount = Int(0)
    
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
        self.menu.reduceMenu()
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
    
    func SettingSidebar(){
        userID = Auth.auth().currentUser?.email
        
        // SideMenuItem Array
        var menuItemArray : Array<SideMenuItem> = []
        for n in AgencySingleton.shared.sidebar_setting{
            if n.controlValue == "AttendSegue"{
                if (!(CBAInfoTabViewController.mainUser.grade == "LEADER")){
                    continue
                }
            }
            if (n.controlValue == "GbsAttendSegue"){
                if (!(CBAInfoTabViewController.mainUser.gbsInfo?.position == "조장")){
                    continue
                }
            }
            
            var tempMenu : SideMenuItem?
            if n.type == "image" {
                tempMenu = SideMenuItemFactory.make(title: n.iconName!){
                    FirebaseModel().FIR_ChangeImage(title: n.controlValue!)
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
	    
        // SIDE BAR SETTING
        let whiteLine = UILabel()
        whiteLine.frame = CGRect(x : viewX! + viewW!*0.035, y : viewY! + viewH!*0.03, width : viewW! * 0.58, height : viewH! * 0.001)
        whiteLine.backgroundColor = UIColor.black
        
        let headerButton = UIButton()
        headerButton.setTitle(" ", for: .normal)
        headerButton.hop()
        headerButton.setTitleColor(UIColor.black, for: .normal)
        headerButton.frame = CGRect(
            x: viewW! * 0.08,
            y: viewH! * 0.13,
            width: viewH! * 0.04 * 3.26,
            height: viewH! * 0.04
        )
        let headerLabel = UILabel()
        
        headerLabel.textColor = UIColor.black
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.adjustsFontSizeToFitWidth = true
        if((Auth.auth().currentUser) != nil){
            headerButton.setTitle(" ", for: .normal)
            headerButton.setImage(UIImage(named: "로그아웃.png"), for: .normal)
            //print(MassageTabViewController.mainUser?.name)
            if(CBAInfoTabViewController.mainUser.name == ""){
                headerLabel.text = "은혜 많이 받으세요 :)"
            }else{
                var tempGrade = ""
                switch(CBAInfoTabViewController.mainUser.grade)
                {
                case "MISSION" :
                    tempGrade = "사역자"
                    break
                case "LEADER" :
                    tempGrade = "리더"
                    break
                case "ADMIN" :
                    tempGrade = "ADMIN"
                    break
                case "MEMBER" :
                    tempGrade = "일반"
                    break
                case "GANSA" :
                    tempGrade = "간사"
                    break
                default:
                    tempGrade = "일반"
                }
                headerLabel.text = CBAInfoTabViewController.mainUser.name + "  |  " + CBAInfoTabViewController.mainUser.campus + "  |  " + tempGrade
            }
            headerButton.addTarget(self, action: #selector(self.LogoutAction(_:)), for: .touchUpInside)
        } else{
            headerButton.setTitle(" ", for: .normal)
            headerButton.setImage(UIImage(named: "로그인.png"), for: .normal)
            
            headerLabel.text = "로그인 해주세요."
            headerButton.addTarget(self, action: #selector(self.LogIn(_:)), for: .touchUpInside)
        }
        
        headerLabel.textAlignment = NSTextAlignment.left
        headerLabel.frame = CGRect(
            x: viewW! * 0.09,
            y: viewH! * 0.18,
            width: viewW! * 0.5,
            height: viewH! * 0.03
        )
        let headerView: UIView = UIView()
        
        let BackImageView: UIImageView = UIImageView()
        BackImageView.image = UIImage(named: AgencySingleton.shared.sidebarBannerName!)
        BackImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let ImageButton = UIButton()
        if(AgencySingleton.shared.AgencyTitle == "2020_CBA_SUMMER"){
            BackImageView.addSubview(headerLabel)
            headerView.addSubview(BackImageView)
            ImageButton.imageView!.image = UIImage(named: AgencySingleton.shared.sidebarBannerName!)
            //ImageButton.backgroundColor = .blue
            ImageButton.frame = CGRect(x:0,y:0,width: viewW!-124, height:viewH!*0.123)
            print(viewW!)
            // 375      250.66666667    22  331     11
            // 414      266.66666667    38  76      11
            
            // 40
            // -228
            // 250
            // 266.6667
            // -228
            //print("YSK : ", SideMenuHeader.getView(T##self: SideMenuHeader##SideMenuHeader))
            
            headerView.addSubview(headerButton)
        }
        else{
            BackImageView.backgroundColor = UIColor.white
            
            ImageButton.setTitleColor(UIColor.black, for: .normal)
            ImageButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            //ImageButton.setTitle("QnaSegue", for: .normal)
            headerView.addSubview(BackImageView)
            
        }
        ImageButton.addTarget(self, action: #selector(self.SetPopup(_:)), for: .touchUpInside)
        headerView.addSubview(ImageButton)
        
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
    
    @objc func LoadImageView(_ notification: Notification){
        // [색보정]이미지 뒤에 색이 분홍색이라 CBA만 보정해줍니다.
        
        if (AgencySingleton.shared.realmAgent == "CBA"){
            // [색보정]이미지 뒤에 색이 분홍색이라 CBA만 보정해줍니다.
            slideshow.backgroundColor = UIColor(red: 209/255, green: 233/255, blue: 237/255, alpha: 1)
        }
        
        
        slideshow.slideIn(from : .right, delay : 0.5)
        slideshow.fadeIn(duration: 0.3)
        slideshow.setImageInputs(FirebaseModel.imageKingfisher)
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.black
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageIndicator
        
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        OpenImageView()
    }
    
    @objc func Logout(_ sender: Any){
        do {
            try Auth.auth().signOut()
            CBAInfoTabViewController.mainUser.setUser(memId: 0, campus: "", mobile: "", name: "", grade: "", retreatGbsInfo: RetreatGBSInfo(retreatId: 0, gbs: "", position: ""), gbsInfo: GBSInfo(gbsName: "", position: ""))
        } catch{
            
        }
        SettingSidebar()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LogoutAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            CBAInfoTabViewController.mainGBS.self = MainGBS(gbsLevel: "", leader: nil, members: nil)
            CBAInfoTabViewController.mainUser.setUser(memId: 0, campus: "", mobile: "", name: "", grade: "", retreatGbsInfo: RetreatGBSInfo(retreatId: 0, gbs: "", position: ""), gbsInfo: GBSInfo(gbsName: "", position: ""))
        } catch{
            
        }
        SettingSidebar()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func LogIn(_ sender:UIButton){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if(!((Auth.auth().currentUser?.email) != nil)){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else{
                // 이럴 일 없음??
            }
        }
        self.dismiss(animated: true, completion: nil)
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
        FirebaseModel().FIR_ReloadMessage()
    }
    
    @objc func SetMonsanpo(_ sender:UIButton){
        CloseImageView()
        RenewRealmData(title: "MONGSANPO")
        AgencySingleton.shared.SetMongsanpoAgency()
        main_popupView.removeFromSuperview()
        FirebaseModel().FIR_ReloadMessage()
    }
    
    @objc func GetNoti(_ sender:UIButton){
        CloseImageView()
        CBAInfoTabViewController.isNotiMessage = true
        self.performSegue(withIdentifier: "QnaSegue", sender: nil)
    }
    
    @objc func GetCall(_ sender: Any) {
        let urlString = "tel://" + "010-3925-7313"
        let numberURL = NSURL(string: urlString)
        UIApplication.shared.open(numberURL! as URL)
        CloseImageView()
    }
    
    @objc func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    func OpenImageView(){
        slideshow.circular = false
        slideshow.frame = CGRect(x: 0, y: viewW! * 0.2, width: viewW!, height: viewH! - viewW! * 0.4)
        notiButton.frame.size = CGSize(width: 0, height: 0)
    }
    
    func CloseImageView(){
        slideshow.slideOut(to: .bottom)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.slideshow.frame.size = CGSize(width: 0, height: 0)
        }
        notiButton.frame = CGRect(x: 0, y: viewH! * 0.75 - viewW!/5, width: viewW!, height: viewH! * 0.25)
    }
    
    @objc func closeTap(_ sender:UIButton) {
        main_popupView.popOut()
        //main_popupView.removeFromSuperview()
    }
    
    lazy var main_popupView = UIView()
    lazy var inner_popupView = UIView()
    lazy var popupView_toptext = UILabel()
    lazy var popupView_blackline = UILabel()
    lazy var popupView_cbaButton = UIButton()
    lazy var popupView_mongsanpoButton = UIButton()
    lazy var popupView_bottomtext = UILabel()
    lazy var popupView_cancleButton = UIButton()
    
    func SetPopupView(){
        dismiss(animated: true, completion: nil)
        
        self.view.addSubview(main_popupView)
        main_popupView.popIn()
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
        popupView_cbaButton.setImage(UIImage(named: "2020Summer_SelectImage.png"), for: UIControl.State.normal)
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
        
        // 뒤로가기
        main_popupView.addSubview(popupView_cancleButton)
        popupView_cancleButton.popIn()
        popupView_cancleButton.backgroundColor = UIColor.white
        popupView_cancleButton.addTarget(self, action: #selector(self.closeTap(_:)), for: .touchUpInside)
        popupView_cancleButton.setImage(UIImage(named: "cancel.png"), for: UIControl.State.normal)
        popupView_cancleButton.backgroundColor = UIColor.white
        popupView_cancleButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(main_popupView).offset(20)
            make.right.equalTo(main_popupView).offset(-20)
            make.height.height.equalTo(18)
            make.width.width.equalTo(18)
            //make.center.equalTo(self.view)
        }
        
    }
    
    @objc func SetPopup(_ sender:UIButton){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
            //self.menu.reduce(onController: self)
        }
        SetPopupView()
    }
    
    @objc func MoveSegue(_ sender:UIButton){
        CloseImageView()
        if(sender.currentTitle! == "SearchGBS"){
            if(Auth.auth().currentUser == nil){
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
        
        self.performSegue(withIdentifier: sender.currentTitle!, sender: nil)
    }
    
    @objc func InfoSegue(_ sender:UIButton){
        CloseImageView()
        
        NoticeViewController.OpenStringValue = sender.currentTitle!
        
        self.performSegue(withIdentifier: "infoSegue", sender: nil)
    }

    var isOpenTimeTable = false
    @objc func ChangeImage(_ sender:UIButton){
        
        if(sender.currentTitle == "timetable"){
            if(isOpenTimeTable == true){
                CloseImageView()
                isOpenTimeTable = false
            } else{
                FirebaseModel().FIR_ChangeImage(title: sender.currentTitle!)
                isOpenTimeTable = true
            }
        } else{
            FirebaseModel().FIR_ChangeImage(title: sender.currentTitle!)
        }
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
    
    @objc func Youtube(_ sender:UIButton){
        CloseImageView()
        
        self.performSegue(withIdentifier: "youtubeSegue", sender: nil)
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
            } else if n.type == "youtube"{
                customButton.addTarget(self, action: #selector(self.Youtube(_:)), for: .touchUpInside)
            }
            
            loopcnt += 1
            ResizeBottomView.addSubview(customButton)
        }
    }
    
    lazy var titleNameButton = UIButton()
    @objc func LoadMainView(_ notification: Notification){
        print("RELOAD VIEW (LoadMainView)")
        if (AgencySingleton.shared.realmAgent == "CBA"){
            // [색보정]이미지 뒤에 색이 분홍색이라 CBA만 보정해줍니다.
            slideshow.backgroundColor = UIColor(red: 209/255, green: 233/255, blue: 237/255, alpha: 1)
            //self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .white
        }
        
        backgroundView.removeFromSuperview()
        backgroundView.image = UIImage(named:AgencySingleton.shared.backgroundImageName!)
        backgroundView.frame = CGRect(x:0,y:-(viewW!/5), width:viewW!, height:viewH!-(viewW!/10))
        backgroundView.alpha = 0.5
        
        //slideshow.addSubview(backgroundView)
        //Firebase에서 내 정보 가져오기
        GetMyData()
        
        NoticeLabel.text = FirebaseModel.mainNotiMessages
        
        hambergerButton.translatesAutoresizingMaskIntoConstraints = false
        hambergerButton.fadeIn(duration: 1)
        hambergerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 41).isActive = true
        hambergerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        hambergerButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.07).isActive = true
        hambergerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        
        TopImageButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        TopImageButtonOutlet.fadeIn(duration: 1)
        TopImageButtonOutlet.setImage(UIImage(named: AgencySingleton.shared.topTagImageName!), for: .normal)
        TopImageButtonOutlet.topAnchor.constraint(equalTo: view.topAnchor, constant: 37).isActive = true
        TopImageButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        TopImageButtonOutlet.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.088).isActive = true
        TopImageButtonOutlet.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.78).isActive = true
        
        ResizeBanner.image = UIImage(named: AgencySingleton.shared.viewBannerName!)
        
        //slideshow
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.frame.size = CGSize(width: 0, height: 0)
        
        ResizeBottomView.translatesAutoresizingMaskIntoConstraints = false
        ResizeBottomView.fadeIn(duration: 1)
        ResizeBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ResizeBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ResizeBottomView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        ResizeBottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        MakeBottomButton(button: AgencySingleton.shared.bottombar_setting)
        
        //ResizeNoti.sizeToFit()
        ResizeNoti.translatesAutoresizingMaskIntoConstraints = false
        ResizeNoti.fadeIn(duration: 1)
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
        ResizeBanner.fadeIn(duration: 1)
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
        Messaging.messaging().isAutoInitEnabled = true
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
        
        // uuid, agent 생성
        SetRealmData(defaultAgent: "CBA");
        
        // CBAInfoTabViewController.currentAgency 요거 Realm에 넣어놔야 함. 그걸로 nil체크!
        if(AgencySingleton.shared.realmAgent != nil){
            if(AgencySingleton.shared.realmAgent == "CBA"){
                AgencySingleton.shared.SetCBAAgency()
            } else if (AgencySingleton.shared.realmAgent == "MONGSANPO"){
                AgencySingleton.shared.SetMongsanpoAgency()
            }
        }
        
        // realm 제거 할 때 사용
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
        loadingPage.popIn(fromScale: 2, duration: 2, delay: 0)
        loadingPage.image = UIImage(named: AgencySingleton.shared.sidebarBannerName!)
        loadingPage.image = UIImage(named: AgencySingleton.shared.viewBannerName!)
        
        // 2020_CBA_SUMMER
        // 2019_SR_SUMMER
        SettingSidebar()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        // load main view!!
        FirebaseModel().FIR_FirstLoadView()
    }
    
    func SetNotificationCenter(){
        NotificationCenter.default.addObserver(self,selector: #selector(self.LoadImageView),name: NSNotification.Name(rawValue: "FIR_ChangeImage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadMainView), name: NSNotification.Name(rawValue: "FIR_ReloadMessage"), object: nil)
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
