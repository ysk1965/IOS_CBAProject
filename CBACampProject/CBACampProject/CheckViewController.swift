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
import SwiftyJSON

class CheckViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var campusArray : [String] = []
    
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
                destinationVC.selectedCampus = campusArray[CampusPicker.selectedRow(inComponent: 0)]
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    } //760
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return campusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return campusArray[row]
    }
    
    func loadcampusData(){
        //Alamofire
        if(Auth.auth().currentUser != nil){
            
            let testuid : String = Auth.auth().currentUser!.uid
            let url = "http://cba.sungrak.or.kr:9000/leaders/\(testuid)/campus/list"
            //let param: Parameters = ["name" : "test"]
            let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
            let alamo = AF.request(url, method: .get, encoding: URLEncoding.default, headers: header)
            
            alamo.responseJSON { response in
                switch response.result{
                case .success(let value):
                    print("success")
                    let json = JSON(value)
                    let results = json["names"].arrayValue

                    for result in results {
                        let test = result.stringValue
                        self.campusArray.append(test)
                    }
                case .failure(let error):
                    print(error)
                }
                /*
                
                let json = JSON(response.result.value)
                if let status = response.response?.statusCode{
                    switch(status){
                    case 200..<300:
                        print("JSON: \(json)")
                        
                    default:
                        print("error with response status: \(status)")
                    }
                }
                 */
                
                DispatchQueue.main.async {
                    self.CampusPicker.reloadAllComponents()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadcampusData()
        
        CampusPicker.delegate = self
        CampusPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
}
