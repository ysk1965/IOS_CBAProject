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
    let campus : String?
    let name : String?
    let mobile : String?
    let retreatGbs : String?
    let grade : String?
    let position : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
    let name : String?
    let age : Int?
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
    // DataPassing
    print("parsing start")
    
    if(Auth.auth().currentUser != nil){
        let url = "http://cba.sungrak.or.kr:9000/getMyInfo/" + (Auth.auth().currentUser?.uid)!
        let urlObj = URL(string: url)
        print(url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let myinfos = try decoder.decode(MyInfo.self, from: data)
                print(myinfos)
                
                if(myinfos.name != nil){
                    CBAInfoTabViewController.mainUser.setUser(
                        campus: myinfos.campus ?? "" ,
                        mobile: myinfos.mobile ?? "" ,
                        name: myinfos.name ?? "",
                        retreatGbs: myinfos.retreatGbs ?? "",
                        grade: myinfos.grade ?? "",
                        position: myinfos.position ?? ""
                    )
                }
                print(CBAInfoTabViewController.mainUser.name)
                
            } catch{
                print(url)
                print("We got an error", error.localizedDescription)
            }
            
            }.resume()
    }
    
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
        let url = "http://cba.sungrak.or.kr:9000/getMyInfo/" + (Auth.auth().currentUser?.uid)!
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let myinfos = try decoder.decode(MyInfo.self, from: data)
                
                if(myinfos.name != nil){
                    CBAInfoTabViewController.mainUser.setUser(
                        campus: myinfos.campus ?? "",
                        mobile: myinfos.mobile ?? "",
                        name: myinfos.name ?? "",
                        retreatGbs: myinfos.retreatGbs ?? "",
                        grade: myinfos.grade ?? "",
                        position : myinfos.position ?? ""
                    )
                }
                
            } catch{
                print(url)
                print("We got an error", error.localizedDescription)
            }
            
            }.resume()
    }
}
