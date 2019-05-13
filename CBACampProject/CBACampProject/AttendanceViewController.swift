//
//  AttendanceViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 5. 13..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit

struct AttendanceInfo: Codable {
    var id : String?
    var date : String?
    var name : String?
    var mobile : String?
    var status : String?
    var note : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile = try values.decodeIfPresent(Int.self, forKey: .mobile)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        note = try values.decodeIfPresent(String.self, forKey: .note)
    }
}

class AttendanceViewController: UIViewController {
    var selectedCampus : String?
    var currentAttendanceInfo : Array<AttendanceInfo>
    @IBOutlet weak var statsText: UILabel!
    @IBOutlet weak var campusName: UILabel!
    
    struct requestAPI{
        var date : String
        var campus : String
    }
    
    var attendCnt : Int = 0
    var allCnt : Int = 0
    var attendPercent : Int = 0
    func setStats(){
        attendPercent = attendCnt / allCnt * 100
        statsText.text = "출석" + attendCnt + "/전체" + allCnt + "/" + attendPercent + "%"
    }
    
    func loadAttendanceData(){
        //Parsing
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:8888/attendance/list"
            let urlObj = URL(string: url)
            // Get으로 requestAPI 쏴서 받는거 알아야 함
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let getAttendanceArray = try decoder.decode(AttendanceInfo.self, from: data)
                    
                    self.currentAttendanceInfo = getAttendanceArray
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAttendanceData()
        campusName.text = selectedCampus
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
