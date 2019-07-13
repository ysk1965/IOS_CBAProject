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
    static var noticeDictionary = Dictionary<String, String>()
    static var sendMessageData = Message(text: "default", time: "default", auth: "default", isStaff : "default")
    static var schedule = ""
    
    var imageNames : Array<String> = []
    static var imageKingfisher : Array<KingfisherSource> = []
    static var noticeImage : Array<KingfisherSource> = []
    
    var ref: DatabaseReference!
    
    func getMessages(messageTitle : String) {
        print("trying to get messages....")
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child(messageTitle)
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                FirebaseModel.messages = []
                for child in result {
                    let snapshotValue = child.value as! [String: AnyObject]
                    let message = snapshotValue["message"] as? String ?? ""
                    let time = snapshotValue["time"] as? String ?? ""
                    let auth = snapshotValue["author"] as? String ?? ""
                    print(message)
                    let isStaff = snapshotValue["isStaff"] as? String ?? ""
                    print(message)
                    FirebaseModel.messages.append(Message(text: message, time: time, auth: auth, isStaff: isStaff))
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got messages"), object: self)
            }
        })
    }
    
    func ChangeImage(title : String){
        self.imageNames.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child(title)
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for i in result {
                    self.imageNames.append(i.value as! String)
                }
            }
            var downloadcnt : Int = 1
            
            for n in self.imageNames {
                Storage.storage().reference(withPath: n).downloadURL { (url, error) in
                    FirebaseModel.imageKingfisher.append(KingfisherSource(url: url!))
                    
                    if(downloadcnt == self.imageNames.count){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change image"), object: self)
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
    
    func GetNoticeInfo(){
        self.imageNames.removeAll()
        
        ref = Database.database().reference().child(AgencySingleton.shared.AgencyTitle!).child("images").child("c2")
        ref.queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for n in result{
                    FirebaseModel.noticeDictionary[n.key] = n.value as! String
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetNoticeInfo"), object: self)
        })
    }
    
    func sendMessage(name: String, message: String) {
        let values = ["author":name, "message":message]
        self.ref.child(AgencySingleton.shared.AgencyTitle!).child("message").setValue(values, withCompletionBlock: {(err, ref) in
            if(err == nil){
            }
        })
    }
    
    func downloadImage(name: String, imageView:UIImageView){
        Storage.storage().reference(withPath: name).downloadURL { (url, error) in
            imageView.kf.setImage(with: url)
        }
    }
    
    func getSchedule() {
        var ref: DatabaseReference!
        print("trying to get schedule...")
        Database.database().reference().child("images")
        
        ref = Database.database().reference().child("images").child("schedule")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? String ?? ""
            print(value)
            FirebaseModel.schedule = value
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "got schedule"), object: self)
        })
    }
}
