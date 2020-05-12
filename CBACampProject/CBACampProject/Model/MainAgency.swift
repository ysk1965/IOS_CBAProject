//
//  MainAgency.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 10..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation
import FirebaseMessaging

struct ButtonType {
    // type : Image or Segue or Call or URL
    var type : String?
    var iconName : String? // sidebar는 text
    // image : imageName
    // segue : segueIdentifier
    // call : phoneNumber
    // URL : URL Link
    
    // SIDEBAR : ImageName
    var controlValue : String?
}


// Make SingleTonClass
class AgencySingleton {
    static let shared = AgencySingleton()
    
    var realmAgent : String?
    var realmUid : String?
    
    var AgencyTitle : String?
    var viewBannerName : String? // View 배너 이미지 이름
    var sidebarBannerName : String? // 사이드 바 배너 이미지 이름
    var topTagImageName : String? // View 중앙 상단 이미지 이름
    var backgroundImageName : String? // View 중앙 상단 이미지 이름
    
    // SIDEBAR 메뉴에 들어갈 내용들 추가
    var sidebar_setting : Array<ButtonType> = []
    // MainView에 들어갈 내용들 추가
    var bottombar_setting : Array<ButtonType> = []
    
    
    private init() {
    }
    
    init(AgencyTitle : String, viewBannerName : String, sidebarBannerName : String, topTagImageName : String, backgroundImageName : String, sidebar_setting: Array<ButtonType>, bottombar_setting : Array<ButtonType>){
        AgencySingleton.shared.AgencyTitle = AgencyTitle
        AgencySingleton.shared.viewBannerName = viewBannerName
        AgencySingleton.shared.sidebarBannerName = sidebarBannerName
        AgencySingleton.shared.topTagImageName = topTagImageName
        AgencySingleton.shared.backgroundImageName = backgroundImageName
        
        AgencySingleton.shared.sidebar_setting = sidebar_setting
        AgencySingleton.shared.bottombar_setting = bottombar_setting
    }
    
    func SetCBAAgency(){
        Messaging.messaging().subscribe(toTopic: "2020_CBA_WINTER") { error in
            print("Subscribed to 2020_CBA_WINTER topic")
        }
        Messaging.messaging().unsubscribe(fromTopic: "2019_SR_SUMMER") { error in
            print("unSubscribed to 2019winter topic")
        }
        
        //CBA Data
        var sidebarArray : Array<ButtonType> = []
        sidebarArray.removeAll()
        sidebarArray.append(ButtonType(type: "segue",iconName: "출석 관리", controlValue: "testSegue"))
        sidebarArray.append(ButtonType(type: "segue",iconName: "GBS 출석 관리", controlValue: "GBSAttandance"))
        sidebarArray.append(ButtonType(type: "image",iconName: "또래별 강의", controlValue: "lecture"))
        sidebarArray.append(ButtonType(type: "image",iconName: "식단", controlValue: "menu"))
        sidebarArray.append(ButtonType(type: "image",iconName: "식사/간식 봉사", controlValue: "mealwork"))
        sidebarArray.append(ButtonType(type: "image",iconName: "청소 구역", controlValue: "cleaning"))
        sidebarArray.append(ButtonType(type: "info",iconName: "숙소", controlValue: "room"))
        sidebarArray.append(ButtonType(type: "info",iconName: "GBS 장소", controlValue: "gbs_place"))
        sidebarArray.append(ButtonType(type: "info",iconName: "캠모 장소", controlValue: "campus_place"))
        
        var bottomArray : Array<ButtonType> = []
        bottomArray.removeAll()
        bottomArray.append(ButtonType(type: "segue",iconName: "제목-없음-1.png", controlValue: "QnaSegue"))
        bottomArray.append(ButtonType(type: "call",iconName: "CALL.png", controlValue: "010-3225-3652"))
        bottomArray.append(ButtonType(type: "image",iconName: "TIMETABLE.png", controlValue: "timetable"))
        bottomArray.append(ButtonType(type: "segue",iconName: "ONAIR.png", controlValue: "StreamingSegue"))
        bottomArray.append(ButtonType(type: "segue",iconName: "GBS.png", controlValue: "SearchGBS")) // GBS Attandance : testSegue
        
        AgencySingleton.shared.AgencyTitle = "2020_CBA_WINTER" // 2019_SR_SUMMER
        AgencySingleton.shared.viewBannerName = "2020Winter_BaseImage.png" // "몽산포_배너.png"
        AgencySingleton.shared.sidebarBannerName = "2020Winter_TopImage.png" // "몽산포_가로배너.png"
        AgencySingleton.shared.topTagImageName = "CBA1.png" // "몽산포.png"
        AgencySingleton.shared.backgroundImageName = "2020Winter_BackImage.png"
        
        AgencySingleton.shared.sidebar_setting = sidebarArray
        AgencySingleton.shared.bottombar_setting = bottomArray
        
        FirebaseModel().FIR_setYoutubeUrl()
    }
    
    func SetMongsanpoAgency(){
        Messaging.messaging().subscribe(toTopic: "2019_SR_SUMMER") { error in
            print("Subscribed to 2019winter topic")
        }
        Messaging.messaging().unsubscribe(fromTopic: "2020_CBA_WINTER") { error in
            print("unSubscribed to 2020winter topic")
        }
        
        //MONGSANPO Data
        var M_sidebarArray : Array<ButtonType> = []
        M_sidebarArray.removeAll()
        M_sidebarArray.append(ButtonType(type: "image",iconName: "초청 인사", controlValue: "c1"))
        // 환영 글은 youtube 예외처리 필요
        M_sidebarArray.append(ButtonType(type: "youtube",iconName: "환영 인사", controlValue: "c2"))
        M_sidebarArray.append(ButtonType(type: "info",iconName: "공지사항", controlValue: "c3"))
        M_sidebarArray.append(ButtonType(type: "info",iconName: "세부 프로그램", controlValue: "c4"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "장소안내", controlValue: "c5"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "안전사고지원", controlValue: "c6"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "여행자보험 관련 안내", controlValue: "c7"))
        M_sidebarArray.append(ButtonType(type: "info",iconName: "협력(후원)기관", controlValue: "c8"))
        
        var M_bottomArray : Array<ButtonType> = []
        M_bottomArray.removeAll()
        M_bottomArray.append(ButtonType(type: "url",iconName: "bottom_1.png", controlValue: "http://cba.sungrak.or.kr:9000/#/register_mongsanpo"))
        M_bottomArray.append(ButtonType(type: "call",iconName: "bottom_2.png", controlValue: "070-7300-6239"))
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_3.png", controlValue: "m3"))
        M_bottomArray.append(ButtonType(type: "segue",iconName: "불편접수.png", controlValue: "QnaSegue"))
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_5.png", controlValue: "m5"))
        
        AgencySingleton.shared.AgencyTitle = "2019_SR_SUMMER"
        AgencySingleton.shared.viewBannerName = "몽산포_배너.png"
        AgencySingleton.shared.sidebarBannerName = "몽산포_사이드바배너.png"
        AgencySingleton.shared.topTagImageName = "몽산포.png"
        AgencySingleton.shared.backgroundImageName = "몽산포_배경.png"
        AgencySingleton.shared.sidebar_setting = M_sidebarArray
        AgencySingleton.shared.bottombar_setting = M_bottomArray
        
        FirebaseModel().FIR_setYoutubeUrl()
    }
}
