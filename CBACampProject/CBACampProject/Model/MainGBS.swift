//
//  MainGBS.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 23..
//  Copyright © 2019년 mac. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import Alamofire
import SwiftyJSON

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

struct MyInfo: Codable {
    let memId : Int?
    let campus : String?
    let name : String?
    let mobile : String?
    let retreatGbs : String?
    let grade : String?
    let position : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        memId = try values.decodeIfPresent(Int.self, forKey: .memId)
        campus = try values.decodeIfPresent(String.self, forKey: .campus)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        retreatGbs = try values.decodeIfPresent(String.self, forKey: .retreatGbs)
        grade = try values.decodeIfPresent(String.self, forKey: .grade)
        position = try values.decodeIfPresent(String.self, forKey: .position)
    }
}

struct MyGBS: Codable {
    let gbsLevel : String?
    let leader: UserInfo?
    let members : [UserInfo]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gbsLevel = try values.decodeIfPresent(String.self, forKey: .gbsLevel)
        leader = try values.decodeIfPresent(UserInfo.self, forKey: .leader)
        members = try values.decodeIfPresent([UserInfo].self, forKey: .members)
    }
}

struct UserInfo: Codable{
    var name : String?
    var age : Int?
    let campus : String?
    let mobile : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        campus = try values.decodeIfPresent(String.self, forKey: .campus)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
    }
}

func GetGBSData(){
    if(Auth.auth().currentUser != nil){
        let url = "http://cba.sungrak.or.kr:9000/getGBSInfo/" + (Auth.auth().currentUser?.uid)!
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let myinfos = try decoder.decode(MyGBS.self, from: data)
                
                if(myinfos.gbsLevel != nil){
                    CBAInfoTabViewController.mainGBS.setGBS(
                        gbsLevel: myinfos.gbsLevel ?? "",
                        leader: myinfos.leader!,
                        members: myinfos.members!
                    )
                    CBAInfoTabViewController.memberCount = myinfos.members!.count
                }
            } catch{
                print(url)
                print("We got an error", error.localizedDescription)
            }
        }.resume()
    }
}

func GetMyData(){
    if(Auth.auth().currentUser != nil){
        let url = "http://cba.sungrak.or.kr:9000/members/info"
        print("TEST : " +  url)
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"
        ]
        let uid : String = (Auth.auth().currentUser?.uid)!
        let params : Parameters = [
            "uid" : uid
        ]
        let alamo = AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header)
        
        alamo.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let memId = json["memId"].intValue
                let name = json["name"].stringValue
                let campus = json["campus"].stringValue
                let dt_birth = json["dt_birth"].stringValue
                let mobile = json["mobile"].stringValue
                let uid = json["uid"].stringValue
                let grade = json["grade"].stringValue
                
                let retreatGbsInfo_retreateId = json["retreatGbsInfo"]["retreatId"].intValue
                let retreatGbsInfo_gbs = json["retreatGbsInfo"]["gbs"].stringValue
                let retreatGbsInfo_position = json["retreatGbsInfo"]["position"].stringValue
                let retreatGBSInfoSend = RetreatGBSInfo(retreatId: retreatGbsInfo_retreateId, gbs: retreatGbsInfo_gbs, position:  retreatGbsInfo_position)
                
                let gbsInfo_gbs = json["gbsInfo"]["gbs"].stringValue
                let gbsInfo_position = json["gbsInfo"]["position"].stringValue
                let GBSInfoSend = GBSInfo(gbsName: gbsInfo_gbs, position: gbsInfo_position)
                
                CBAInfoTabViewController.mainUser.setUser(memId: memId, campus: campus, mobile: mobile, name: name, grade: grade, retreatGbsInfo: retreatGBSInfoSend, gbsInfo: GBSInfoSend)
                if(retreatGbsInfo_gbs != nil){
                    GetGBSData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
