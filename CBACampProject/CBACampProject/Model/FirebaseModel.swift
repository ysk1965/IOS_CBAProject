import Foundation
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseStorage
import ImageSlideshow

struct ImageInfo {
    var imageKey : String
    var imageName : String
}

class FirebaseModel {
    static var messages = [Message]()
    static var mainNotiMessages = String()
    static var noticeDictionary = Dictionary<String, String>()
    static var noticeArray = [(key: String, value: String)]()
    static var sendMessageData = Message(text: "default", time: "default", auth: "default", isStaff : "default", uid : "default")
    static var schedule = ""
    
    var imageNames : Array<String> = []
    static var imageKingfisher : Array<KingfisherSource> = []
    static var noticeImage : Array<KingfisherSource> = []
    static var youtubeImage : Array<KingfisherSource> = []
    var settingImage = [(key: String, value: KingfisherSource)]()
    
    static var youtubeURL : Array<String> = []
    
    var ref: DatabaseReference!
    
    func FIR_FirstLoadView(){
        print("First View Loaded")
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("noti")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                FirebaseModel.messages = []
                for child in result {
                    let snapshotValue = child.value as! [String: AnyObject]
                    
                    let isStaff = snapshotValue["isStaff"] as? String ?? ""
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    let uid = snapshotValue["uid"] as? String ?? ""
                    
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff, uid : uid))
                }
                
                let count = FirebaseModel.messages.count
                    
                // 공지 글 받아오기
                for i in (0..<count).reversed(){
                    if(FirebaseModel.messages[i].isStaff == "공지"){
                        FirebaseModel.mainNotiMessages = FirebaseModel.messages[i].text
                        
                        break
                    }
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_ReloadMessage"), object: self)
            }
        })
    }
    
    
    func FIR_ReloadMessage() {
        print("trying to get messages....")
        FirebaseModel.messages.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("noti")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                FirebaseModel.messages = []
                
                for child in result {
                    let snapshotValue = child.value as! [String: AnyObject]
                    
                    let uid = snapshotValue["uid"] as? String ?? ""
                    let isStaff = snapshotValue["isStaff"] as? String ?? ""
                    //print(uid)
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff, uid : uid))
                }
                
                // 메인 메세지 받기
                let count = FirebaseModel.messages.count
                
                for i in (0..<count).reversed(){
                    if(FirebaseModel.messages[i].isStaff == "공지"){
                        FirebaseModel.mainNotiMessages = FirebaseModel.messages[i].text
                        
                        break
                    }
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_ReloadMessage"), object: self)
            }
        })
    }
    
    
    func FIR_GetMessage(messageTitle : String) {
        print("trying to get messages....")
        FirebaseModel.messages.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child(messageTitle)
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                FirebaseModel.messages = []
                for child in result {
                    let snapshotValue = child.value as! [String: AnyObject]
                    
                    let uid = snapshotValue["uid"] as? String ?? ""
                    let isStaff = snapshotValue["isStaff"] as? String ?? ""
                    //print(uid)
                    // 성락교회 앱의 경우 자신에게 온 메세지만 받으면 됨
                    if(AgencySingleton.shared.AgencyTitle == "2019_SR_SUMMER"){
                        if(messageTitle == "message"){
                            if(uid != AgencySingleton.shared.realmUid){
                                continue
                            }
                        }
                    }
                    
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff, uid : uid))
                }
                
                // 메인 메세지 받기
                if(messageTitle == "noti"){
                    let count = FirebaseModel.messages.count
                    
                    for i in (0..<count).reversed(){
                        if(FirebaseModel.messages[i].isStaff == "공지"){
                            FirebaseModel.mainNotiMessages = FirebaseModel.messages[i].text
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_GetMessage"), object: self)
            }
        })
    }
    
    func FIR_ChangeImage(title : String){
        print("Image Setting")
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child(title)
        ref.queryOrderedByValue().observe(DataEventType.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                print(result)
                for i in result {
                    self.imageNames.append(i.value as! String)
                }
            }
            var downloadcnt : Int = 1

            FirebaseModel.imageKingfisher.removeAll()
            self.settingImage.removeAll()
            for n in self.imageNames {
                print(downloadcnt)
                Storage.storage().reference(withPath: AgencySingleton.shared.AgencyTitle! + "/" + n).downloadURL { (url, error) in
                    
                    if(url == nil){
                        print(n + " : url is nil")
                        return
                    }
                    self.settingImage.append((key: n, value:KingfisherSource(url: url!)))
                    
                    if(downloadcnt == self.imageNames.count){
                        let temp = self.settingImage.sorted(by: { $0.key < $1.key })
                        
                        for i in temp{
                            FirebaseModel.imageKingfisher.append(i.value)
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_ChangeImage"), object: self)
                    }
                    
                    downloadcnt += 1
                }
            }
        })
    }
    
    func FIR_YoutubeImage(title : String){
        //self.imageNames.removeAll()
        FirebaseModel.youtubeImage.removeAll()
        settingImage.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child(title)
        ref.queryOrderedByValue().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for i in result {
                    self.imageNames.append(i.value as! String)
                }
            }
            var downloadcnt : Int = 1
            
            for n in self.imageNames {
                Storage.storage().reference(withPath: AgencySingleton.shared.AgencyTitle! + "/" + n).downloadURL { (url, error) in
                    
                    if(url == nil){
                        print(n + " : url is nil")
                        return
                    }
                    self.settingImage.append((key: n, value:KingfisherSource(url: url!)))
                    
                    if(downloadcnt == self.imageNames.count){
                        let temp = self.settingImage.sorted(by: { $0.key < $1.key })
                        
                        for i in temp{
                            FirebaseModel.youtubeImage.append(i.value)
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_SetImage"), object: self)
                    }
                    
                    downloadcnt += 1
                }
            }
        })
    }
    
    func GetNoticeImageInfo(title : String) {
        FirebaseModel.noticeImage.removeAll()
        let path = AgencySingleton.shared.AgencyTitle! + "/" + title
        Storage.storage().reference(withPath: path).downloadURL { (url, error) in
            FirebaseModel.noticeImage.append(KingfisherSource(url: url!))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_SetImage"), object: self)
        }
    }
    
    func GetNoticeInfo(title: String){
        self.imageNames.removeAll()
        FirebaseModel.noticeDictionary.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child(title)
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                /*
                for n in result{
                    FirebaseModel.noticeDictionary[n.key] = n.value as! String
                }
                */
                for i in (0..<result.count){
                    print(FirebaseModel.noticeDictionary)
                    FirebaseModel.noticeDictionary[result[i].value as! String] = result[i].key
                }
            }
            let a = FirebaseModel.noticeDictionary.sorted(by: <)
            FirebaseModel.noticeArray = a
            //print(FirebaseModel.noticeDictionary)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetNoticeInfo"), object: self)
        })
    }
    
    func sendMessage(name: String, message: String, title: String) {
        let values = ["author":name, "message":message, "uid": AgencySingleton.shared.realmUid]
        self.ref.child(AgencySingleton.shared.AgencyTitle!).child(title).setValue(values, withCompletionBlock: {(err, ref) in
            if(err == nil){
            }
            print("success")
        })
    }
    
    func downloadImage(name: String, imageView:UIImageView){
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        Storage.storage().reference(withPath: name).downloadURL { (url, error) in
            imageView.kf.setImage(with: url, placeholder:nil, options:[.processor(processor)])
        }
    }
    
    func FIR_setYoutubeUrl(){
        self.imageNames.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("setting")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for i in result {
                    FirebaseModel.youtubeURL.append(i.value as? String ?? "")
                }
            }
            print(FirebaseModel.youtubeURL)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetYoutube"), object: self)
        })
    }
    
    class PushNotificationSender {
        /*
                   //요기에 alamofire추기
                   if(Auth.auth().currentUser != nil){
                       let url = "https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send HTTP/1.1"
                       let message : String = SettingDate() // 현재 날짜
                       let campusName : String = selectedCampus!
                       
                       
                       let params : Parameters = [
                           "date" : date,
                           "campus" : campusName
                       ]
                       
                       print(date)
                       
                       let header: HTTPHeaders = ["Authorization" : "Basic YWRtaW46ZGh3bHJybGVoISEh"]
                       let alamo = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
                       
                       alamo.responseJSON { response in
                           print("JSON_Alamo=\(response.result.value!)")
                           
                           if(response.result.error != nil) {
                               print(response.result.error!)
                               return;
                           }
                           let json = JSON(response.result.value!)
                           let results = json["data"].arrayValue
                           
                           print(json)
                           if let status = response.response?.statusCode{
                               switch(status){
                               case 200..<300:
                                   
                                   print("success")
                                   print("JSON: \(json)")
                                   
                               default:
                                   print("error with response status: \(status)")
                               }
                           }
                       }
                   }
                    */
        
        func sendPushNotification(to subject: String, title: String, body: String) {
            let urlString = "https://fcm.googleapis.com/v1/projects/cba-retreat/messages:send"
            let url = NSURL(string: urlString)!
            let message: [String : Any] = ["topic" : subject,
                                               "notification" : ["title" : title, "body" : body]
            ]
            print(message)
            
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:message, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer AAAA-PRsYvs:APA91bFiNlDHb8bBp5N4CJJuhtNSiV4Ej1KIh3tkIRsUbfrmHcCPvJvphxAWwg2oLohhgll1Ui0owWyRSP3nrkSDSrnr6M3ktjo75p2YFeqSl24naWo5ILf0yXVbWu08EvbqX0w8SoGSFFml6SmwIOh12ZmAgP1bMg", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
                        {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
        }
    }
}
