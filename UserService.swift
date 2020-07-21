
import UIKit
import Alamofire
import SwiftyJSON

class UserService: NSObject {
    var param: [String: Any]!
    
    class func getUser(id: Int,completionHandler: @escaping(_ success: Bool, _ user: User?, _ error: Error?)->Void){
        let urlString = "https://reqres.in/api/users/\(id)"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data)
                if let employee = User.createUser(json: jsonData["data"]){
                    completionHandler(true,employee,nil)
                }
            case .failure(let error):
                completionHandler(false,nil,error)
            }
        }
        
    }
    
    class func getUsers(page: Int,completionHandler: @escaping(_ success: Bool, _ users: [User]?,_ error: Error?, _ totalPages: Int?)->Void){
        let urlString = "https://reqres.in/api/users?page=\(page)"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result{
            case .success(let data):
                let totalPages = JSON(data)["total_pages"].int
                if let jsonArray = JSON(data)["data"].array{
                    print(jsonArray)
                    if let employee = User.createUsersArray(jsonArray: jsonArray){
                        completionHandler(true, employee, nil, totalPages)
                    }
                }
            case .failure(let error):
                completionHandler(false,nil,error, 1)
            }
        }
    }
    
    class func deleteUser(id: Int,completionHandler: @escaping(_ success: Bool,_ error: Error?)->Void){
        let urlString = "http://dummy.restapiexample.com/api/v1/delete/\(id)"
        Alamofire.request(urlString, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result{
            case .success(let data):
                print(data)
                completionHandler(true,nil)
            case .failure(let error):
                completionHandler(false,error)
            }
        }
    }
}
