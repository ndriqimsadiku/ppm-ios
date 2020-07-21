import UIKit
import SwiftyJSON


class User: NSObject {
    var id: Int?
    var email: String?
    var first_name: String?
    var last_name: String?
    var avatar: String?
    
    
    static func createUser(json: JSON) -> User?{
        let user = User()
        if let id = json["id"].int{
            user.id = id
            if let email = json["email"].string{
                user.email = email
            }
            if let first_name = json["first_name"].string{
                user.first_name = first_name
            }
            if let last_name = json["last_name"].string{
                user.last_name = last_name
            }
            if let avatar = json["avatar"].string{
                user.avatar = avatar
            }
            return user
        }
        return nil
    }
    
    static func createUsersArray(jsonArray: [JSON]) -> [User]? {
        var usersArray: [User] = []
        for jsonObj in jsonArray{
            if let user = User.createUser(json: jsonObj){
                usersArray.append(user)
            }
        }
        return usersArray
    }
}
