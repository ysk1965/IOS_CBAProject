//
//  User.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation


struct RetreatGBSInfo {
    let retreatId : Int?
    let gbs : String?
    let position : String?
    init(retreatId:Int, gbs:String, position:String) {
        self.retreatId = retreatId
        self.gbs = gbs
        self.position = position
    }
}

struct GBSInfo {
    let gbsName : String?
    let position : String?
    
    init(gbsName:String, position:String) {
        self.gbsName = gbsName
        self.position = position
    }
}

class MainUser{
    var memId : Int
    var campus : String
    var mobile : String
    var name : String
    var grade : String
    var retreatGbsInfo : RetreatGBSInfo?
    var gbsInfo : GBSInfo?
    
    init(memId:Int ,campus:String, mobile:String, name : String, grade : String, retreatGbsInfo : RetreatGBSInfo?, gbsInfo : GBSInfo?) {
        self.memId = memId
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.grade = grade
        self.retreatGbsInfo = retreatGbsInfo
        self.gbsInfo = gbsInfo
    }
    
    func setUser(memId:Int, campus:String, mobile:String, name : String, grade : String, retreatGbsInfo : RetreatGBSInfo, gbsInfo : GBSInfo){
        self.memId = memId
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.grade = grade
        self.retreatGbsInfo = retreatGbsInfo
        self.gbsInfo = gbsInfo
    }
}
