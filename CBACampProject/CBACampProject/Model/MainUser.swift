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
