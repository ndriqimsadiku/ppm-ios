

import UIKit
import CoreData

class UpdateCoreDataViewController: UIViewController {
    
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var avatar: String?

    
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Update Core Data"
        
        txtID.text = "\(id ?? 0)"
        txtFirstName.text = first_name
        txtLastName.text = last_name
        txtEmail.text = email
    }
    
    func updateEmployee(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "id =  %d", id!)
        
        do {
            let users = try context?.fetch(request)
            for user in users!{
                (user as AnyObject).setValue(txtFirstName.text, forKey: "first_name")
                (user as AnyObject).setValue(txtLastName.text, forKey: "last_name")
                (user as AnyObject).setValue(txtEmail.text, forKey: "email")
            }
            try context?.save()
            print("Update succeeded")
        } catch{
            print("Update failed")
        }
    }

    @IBAction func btnSave(_ sender: Any) {
        updateEmployee()
        navigationController?.popViewController(animated: true)
    }
}
