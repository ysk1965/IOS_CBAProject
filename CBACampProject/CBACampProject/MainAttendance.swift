//
//  MainGBS.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation

class MainAttendance {
    var id : String?
    var date : String?
    var name : String?
    var mobile : String?
    var status : String?
    var note : String?
    
    init(id: String, date: String, name: String, mobile: String, status: String, note: String) {
        self.id = id
        self.date = date
        self.name = name
        self.mobile = mobile
        self.status = status
        self.note = note
    }
    
    func setAttendance(id: String, date: String, name: String, mobile: String, status: String, note: String){
        self.id = id
        self.date = date
        self.name = name
        self.mobile = mobile
        self.status = status
        self.note = note
    }
}
