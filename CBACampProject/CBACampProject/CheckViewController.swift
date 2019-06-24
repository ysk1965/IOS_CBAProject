//
//  CheckViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 3. 27..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class CheckViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var campusArray : [String] = []
    var selectRow : Int = 0
    
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var CampusPicker: UIPickerView!
    
    @IBAction func Back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func moveAction(_ sender: Any) {
        self.performSegue(withIdentifier: "checkIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "checkIdentifier"{
            if let destinationVC = segue.destination as? AttendanceViewController {
                destinationVC.selectedCampus = campusArray[selectRow]
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return campusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return campusArray[row]
    }
    
    private func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
    
    func loadcampusData(){
        /*
        //Parsing
        if(Auth.auth().currentUser != nil){
            //var url = "http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)! + "/campus/list"
            // test
            let url = "http://admin:dhwlrrleh!!!@cba.sungrak.or.kr:9000/members/search?name=다인"
            let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let urlObj = URL(string: encoded)
    
            
            URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let getCampusArray = try decoder.decode(Array<String>.self, from: data)
                    
                    self.campusArray = getCampusArray
                } catch{
                    print(url)
                    print("We got an error", error.localizedDescription)
                }
                
                }.resume()
        }
        */
        
        //Alamofire 버젼
        //Parsing
        if(Auth.auth().currentUser != nil){
            let url = "http://cba.sungrak.or.kr:9000/members/search"
            let param: Parameters = ["name" : "다인"]
            let header: Parameters = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = Alamofire.request(url, method: .post, parameters : param, headers: header, encoding: URLEncoding.httpBody)
            
            alamo.responseJSON(){ response in
                if let status = response.response?.statusCode{
                    switch(status){
                    case 201:
                        print("success")
                        
                        print("JSON: \(response.result.value!)")
                        if let jsonObject = response.result.value as? [String: Any] {
                            print("name: \(jsonObject["name"]!)")
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }

            }
        }
        
        // 임시 테스트용
        /*
        campusArray.append("TESTDATA1")
        campusArray.append("TESTDATA2")
        campusArray.append("TESTDATA3")
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadcampusData()
        
        CampusPicker.delegate = self
        CampusPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
}
