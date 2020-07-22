import UIKit
import Alamofire
import SwiftyJSON

class NbaService: NSObject {
    
    var param: [String: Any]!
    
    static let header  = ["X-RapidAPI-Host":"free-nba.p.rapidapi.com","X-RapidAPI-Key": "e071e2f77emshf265bd719a4286fp1dedcajsnc7d4a7b3d608"]
    
    class func getTeam(id: Int,completionHandler: @escaping(_ success: Bool, _ user: Team?, _ error: Error?)->Void){
        let urlString = "https://free-nba.p.rapidapi.com/teams/\(id)"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data)
                if let team = Team.createTeam(json: jsonData){
                    completionHandler(true,team,nil)
                }
            case .failure(let error):
                completionHandler(false,nil,error)
            }
        }
        
    }
    
    class func getTeams(completionHandler: @escaping(_ success: Bool, _ users: [Team]?,_ error: Error?)->Void){
        let urlString = "https://free-nba.p.rapidapi.com/teams"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result{
            case .success(let data):
                if let jsonArray = JSON(data)["data"].array{
                    if let team = Team.createTeamArray(jsonArray: jsonArray){
                        completionHandler(true, team, nil)
                    }
                }
            case .failure(let error):
                completionHandler(false,nil,error)
            }
        }
    }

}
