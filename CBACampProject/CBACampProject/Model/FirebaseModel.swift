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
    static var sendMessageData = Message(text: "default", time: "default", auth: "default", isStaff : "default")
    static var schedule = ""
    
    var imageNames : Array<String> = []
    static var imageKingfisher : Array<KingfisherSource> = []
    static var noticeImage : Array<KingfisherSource> = []
    static var youtubeImage : Array<KingfisherSource> = []
    var settingImage = [(key: String, value: KingfisherSource)]()
    
    static var youtubeURL : Array<String> = []
    
    var ref: DatabaseReference!
    
    func FIR_FirstLoadView(){
        print("First!! Load!!")
        
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
                    
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff))
                }
                
                let count = FirebaseModel.messages.count
                    
                for i in (0..<count).reversed(){
                    if(FirebaseModel.messages[i].isStaff == "공지"){
                        FirebaseModel.mainNotiMessages = FirebaseModel.messages[i].text
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_ReloadMessage"), object: self)
                        
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
                    print(uid)
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    print(message)
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff))
                }
                
                // 메인 메세지 받기
                let count = FirebaseModel.messages.count
                
                for i in (0..<count).reversed(){
                    if(FirebaseModel.messages[i].isStaff == "공지"){
                        FirebaseModel.mainNotiMessages = FirebaseModel.messages[i].text
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FIR_ReloadMessage"), object: self)
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
                    print(uid)
                    if(messageTitle == "message"){
                        if(uid != AgencySingleton.shared.realmUid){
                            continue
                        }
                    }
                    
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    print(message)
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff))
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
        self.imageNames.removeAll()
        FirebaseModel.imageKingfisher.removeAll() // 요거면 3번 해결되려나??
        settingImage.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child(title)
        ref.queryOrderedByValue().observe(DataEventType.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                print(result)
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
                            print(i.key)
                            FirebaseModel.imageKingfisher.append(i.value)
                        }
                        print("마지막 애 받으면 넘겨")
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
                            print(i.key)
                            FirebaseModel.youtubeImage.append(i.value)
                        }
                        print("마지막 애 받으면 넘겨")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "set image"), object: self)
                    }
                    
                    downloadcnt += 1
                }
            }
        })
    }
    
    func GetNoticeImageInfo(title : String) {
        FirebaseModel.noticeImage.removeAll()
        let path = "2019_SR_SUMMER/" + title
        Storage.storage().reference(withPath: path).downloadURL { (url, error) in
            FirebaseModel.noticeImage.append(KingfisherSource(url: url!))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "set image"), object: self)
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
                print("확인해봐!!!")
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
        })
    }
    
    func downloadImage(name: String, imageView:UIImageView){
        Storage.storage().reference(withPath: name).downloadURL { (url, error) in
            imageView.kf.setImage(with: url)
        }
    }
    
    func setYoutubeUrl(){
        self.imageNames.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("setting")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for i in result {
                    FirebaseModel.youtubeURL.append(i.value as! String)
                }
            }
            print(FirebaseModel.youtubeURL)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetYoutube"), object: self)
        })
    }
}
