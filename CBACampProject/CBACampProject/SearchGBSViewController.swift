//
//  SearchGBSViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 11..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

struct MyGBS: Codable {
    let gbsLevel : Int?
    let leader: UserInfo?
    let members : [UserInfo]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gbsLevel = try values.decodeIfPresent(Int.self, forKey: .gbsLevel)
        leader = try values.decodeIfPresent(UserInfo.self, forKey: .leader)!
        members = try values.decodeIfPresent([UserInfo].self, forKey: .members)!
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

class SearchGBSViewController: UIViewController, UIScrollViewDelegate {
    var gbsLevel : Int?
    @IBOutlet weak var MainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/getGBSInfo/" + (Auth.auth().currentUser?.uid)!
            let urlObj = URL(string: url)
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    var myGBSs = try decoder.decode(MyGBS.self, from: data)
                    
                    
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
