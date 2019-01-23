//
//  MainGBS.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation

class MainGBS {
    var gbsLevel : String?
    var leader: UserInfo?
    var members : [UserInfo]?
    
    init(gbsLevel: String, leader:UserInfo?, members:[UserInfo]?) {
        self.gbsLevel = gbsLevel
        self.leader = leader
        self.members = members
    }
    
    func setGBS(gbsLevel: String, leader:UserInfo, members:[UserInfo]){
        self.gbsLevel = gbsLevel
        self.leader = leader
        self.members = members
    }
}
