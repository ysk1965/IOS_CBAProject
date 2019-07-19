//
//  MainAgency.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 7. 10..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation

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
    
    // SIDEBAR 메뉴에 들어갈 내용들 추가
    var sidebar_setting : Array<ButtonType> = []
    // MainView에 들어갈 내용들 추가
    var bottombar_setting : Array<ButtonType> = []
    
    
    private init() {
    }
    
    init(AgencyTitle : String, viewBannerName : String, sidebarBannerName : String, topTagImageName : String, sidebar_setting: Array<ButtonType>, bottombar_setting : Array<ButtonType>){
        AgencySingleton.shared.AgencyTitle = AgencyTitle
        AgencySingleton.shared.viewBannerName = viewBannerName
        AgencySingleton.shared.sidebarBannerName = sidebarBannerName
        AgencySingleton.shared.topTagImageName = topTagImageName
        
        AgencySingleton.shared.sidebar_setting = sidebar_setting
        AgencySingleton.shared.bottombar_setting = bottombar_setting
    }
    
    func SetCBAAgency(){
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
        
        AgencySingleton.shared.AgencyTitle = "2019_CBA_SUMMER" // 2019_SR_SUMMER
        AgencySingleton.shared.viewBannerName = "배너.png" // "몽산포_배너.png"
        AgencySingleton.shared.sidebarBannerName = "CBA_사이드바.png" // "몽산포_가로배너.png"
        AgencySingleton.shared.topTagImageName = "CBA.png" // "몽산포.png"
        AgencySingleton.shared.sidebar_setting = sidebarArray
        AgencySingleton.shared.bottombar_setting = bottomArray
        
        FirebaseModel().setYoutubeUrl()
    }
    
    func SetMongsanpoAgency(){
        
        //MONGSANPO Data
        var M_sidebarArray : Array<ButtonType> = []
        M_sidebarArray.removeAll()
        M_sidebarArray.append(ButtonType(type: "segue",iconName: "초청의 글(원로 감독님)", controlValue: "youtubeSegue"))
        // 환영 글은 youtube 예외처리 필요
        M_sidebarArray.append(ButtonType(type: "segue",iconName: "환영의 글(감독님)", controlValue: "youtubeSegue"))
        M_sidebarArray.append(ButtonType(type: "segue",iconName: "공지사항", controlValue: "infoSegue"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "프로그램", controlValue: "m3"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "장소안내", controlValue: "c4"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "안전사고지원", controlValue: "c5"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "여행자보험 관련 안내", controlValue: "c5"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "협력(후원)기관", controlValue: "c5"))
        
        var M_bottomArray : Array<ButtonType> = []
        M_bottomArray.removeAll()
        M_bottomArray.append(ButtonType(type: "url",iconName: "bottom_1.png", controlValue: "campus_place"))
        M_bottomArray.append(ButtonType(type: "call",iconName: "bottom_2.png", controlValue: "070-7300-6239"))
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_3.png", controlValue: "m3"))
        M_bottomArray.append(ButtonType(type: "segue",iconName: "bottom_4.png", controlValue: "QnaSegue"))
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_5.png", controlValue: "m5"))
        
        AgencySingleton.shared.AgencyTitle = "2019_SR_SUMMER"
        AgencySingleton.shared.viewBannerName = "몽산포_배너.png"
        AgencySingleton.shared.sidebarBannerName = "몽산포_사이드바.png"
        AgencySingleton.shared.topTagImageName = "몽산포.png"
        AgencySingleton.shared.sidebar_setting = M_sidebarArray
        AgencySingleton.shared.bottombar_setting = M_bottomArray
        
        FirebaseModel().setYoutubeUrl()
    }
}
