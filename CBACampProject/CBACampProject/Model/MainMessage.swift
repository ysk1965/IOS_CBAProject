import Foundation

class Message {
    var text : String
    var time : String
    var auth : String
    var isStaff : String
    
    init(text: String, time:String, auth:String, isStaff : String) {
        self.text = text
        self.time = time
        self.auth = auth
        self.isStaff = isStaff
    }
    
    func setMessage(text: String, time:String, auth:String, isStaff : String){
        self.text = text
        self.time = time
        self.auth = auth
        self.isStaff = isStaff
    }
}
