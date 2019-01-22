//
//  SearchGBSViewController.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 1. 11..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class SearchGBSViewController: UIViewController {

    var allURLs = [String]()
    var allTitles = [String]()
    var allmembersDicts = [[String : Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //parseURL(theURL : "http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)!)
        
        jsonParser(theURL : "http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)!)
        
        print("http://cba.sungrak.or.kr:8888/getMyInfo/" + (Auth.auth().currentUser?.uid)!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func jsonParser(theURL:String){
        let strJSonString = theURL
        let oJsonDataT:Data? = strJSonString.data(using: .utf8)
        
        if let oJsonData = oJsonDataT
        {
            var oJsonDictionaryT:[String:Any]?
            oJsonDictionaryT = try! JSONSerialization.jsonObject(with: oJsonData, options: []) as! [String:Any]
            
            if let oJsonDictionary = oJsonDictionaryT
            {
                if let name = oJsonDictionary["name"],
                    let campus = oJsonDictionary["campus"]
                {
                    print("name = \(name)")
                    print("name = \(campus)")
                }
            }
        }
    }
    
    func parseURL(theURL:String){
        let url = URL(string: theURL)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil{
                print("didn`t work, \(String(describing: error))")
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    
                    // just deal
                }
            } else{
                do{
                    let parseData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    
                    //self.allmembersDicts.removeAll() // replace data
                
                    for (key, value) in parseData{
                        //print("\(key) --- \(value)")
                        
                        if(key == "members"){
                        
                            if let membersArray: [[String : Any]] = value as? [[String : Any]]{
                                
                                self.allmembersDicts = membersArray
                                
                                print("is array of dictionaries")
                                
                                for dict in membersArray{
                                    for (key, value) in dict{
                                        if(key == "url"){
                                            print("url is \(value)")
                                            self.allURLs.append(value as! String)
                                        } else if (key == "title"){
                                            print("title is \(value)")
                                            self.allURLs.append(value as! String)
                                        } else if (key == "source"){
                                            if let sourceDict:[String : Any] = value as? [String : Any]{
                                                print (sourceDict)
                                                
                                                for (key, value) in sourceDict{
                                                    if (key == "id"){
                                                        print(value)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                } catch let error as NSError{
                    print(error)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()){
                        
                    }
                    // just deal
                }
            }
        }.resume()
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
