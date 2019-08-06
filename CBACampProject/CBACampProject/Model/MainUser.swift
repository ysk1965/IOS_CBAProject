//
//  User.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation

class MainUser{
    var campus : String
    var mobile : String
    var name : String
    var retreatGbs : String
    var grade : String
    
    init(campus:String, mobile:String, name : String, retreatGbs : String, grade : String) {
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.retreatGbs = retreatGbs
        self.grade = grade
    }
    
    func setUser(campus:String, mobile:String, name : String, retreatGbs : String, grade : String){
        self.campus = campus
        self.mobile = mobile
        self.name = name
        self.retreatGbs = retreatGbs
        self.grade = grade
    }
}
