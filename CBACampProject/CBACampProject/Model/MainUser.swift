//
//  User.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation

class MainUser {
    var age : Int
    var campus : String
    var mobile : String
    var name : String
    var gbsLevel : String
    var grade : String
    
    init(age: Int, campus:String, mobile:String, name : String, gbsLevel : String, grade : String) {
        self.age = age
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.gbsLevel = gbsLevel
        self.grade = grade
    }
    
    func setUser(age: Int, campus:String, mobile:String, name : String, gbsLevel : String, grade : String){
        self.age = age
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.gbsLevel = gbsLevel
        self.grade = grade
    }
}

struct ButtonType(){
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
    
    // 쓸지 고민 중...
    private init() {}
    
    private init(AgencyTitle : String, viewBannerName : String, sidebarBannerName : String, topTagImageName : String, sidebar_setting: Array<ButtonType>, bottombar_setting : Array<ButtonType>){
        self.AgencyTitle = AgencyTitle
        self.viewBannerName = image_name
        self.sidebarBannerName = sidebarBannerName
        self.topTagImageName = topTagImageName
        
        self.sidebar_setting = sidebar_setting
        self.bottombar_setting = view_setting
    }
}
