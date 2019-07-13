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
        AgencySingleton.shared.sidebarBannerName = "CBA가로배너.png" // "몽산포_가로배너.png"
        AgencySingleton.shared.topTagImageName = "CBA.jpeg" // "몽산포.png"
        AgencySingleton.shared.sidebar_setting = sidebarArray
        AgencySingleton.shared.bottombar_setting = bottomArray
    }
    
    func SetMongsanpoAgency(){
        
        //MONGSANPO Data
        var M_sidebarArray : Array<ButtonType> = []
        M_sidebarArray.removeAll()
        M_sidebarArray.append(ButtonType(type: "segue",iconName: "공지사항", controlValue: "infoSegue"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "1", controlValue: "gbs_place"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "2", controlValue: "menu"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "3", controlValue: "mealwork"))
        M_sidebarArray.append(ButtonType(type: "image",iconName: "4", controlValue: "cleaning"))
        
        var M_bottomArray : Array<ButtonType> = []
        M_bottomArray.removeAll()
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_1.png", controlValue: "campus_place"))
        M_bottomArray.append(ButtonType(type: "call",iconName: "bottom_2.png", controlValue: "010-6623-2545"))
        M_bottomArray.append(ButtonType(type: "image",iconName: "bottom_3.png", controlValue: "timetable"))
        M_bottomArray.append(ButtonType(type: "segue",iconName: "bottom_4.png", controlValue: "infoSegue"))
        M_bottomArray.append(ButtonType(type: "segue",iconName: "bottom_5.png", controlValue: "MapSegue"))
        
        AgencySingleton.shared.AgencyTitle = "2019_SR_SUMMER"
        AgencySingleton.shared.viewBannerName = "몽산포_배너.png"
        AgencySingleton.shared.sidebarBannerName = "몽산포_가로배너.png"
        AgencySingleton.shared.sidebar_setting = M_sidebarArray
        AgencySingleton.shared.bottombar_setting = M_bottomArray
    }
}
