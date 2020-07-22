

import UIKit
import Alamofire
import SwiftyJSON

class APICreateUserViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Create User"
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        let json: [String:String] = ["email" : email, "password" : password]
        
        let urlString = "https://reqres.in/api/register"
        Alamofire.request(urlString, method: .post, parameters: json, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print(response)
        }
    }
}
