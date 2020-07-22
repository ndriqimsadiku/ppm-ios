

import UIKit
import CoreData
import ImageLoader

class CoreDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tblUsers: UITableView!
    var usersArray: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Core Data"
        addNotificationObserver()
        getUsersFromApi()
        setupTable()
    }
    
    func setupTable(){
        tblUsers.delegate = self
        tblUsers.dataSource = self
        tblUsers.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
    }
    
    func getUsersFromApi(){
        UserService.getUsers(page: 1) { (success, users, error, tPages) in
            if(success){
                if let newUserArray = users {
                    for user in newUserArray{
                        if(!self.userExists(id: user.id!)){
                            self.saveUser(user: user)
                        }
                    }
                    self.getUsers()
                    self.tblUsers.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        let user = usersArray[indexPath.row]
        
        cell.lblID.text = "ID: \(user.id ?? 0)"
        cell.lblFirstName.text = "First Name: \(user.first_name ?? "")"
        cell.lblLastName.text = "Last Name: \(user.last_name ?? "")"
        cell.lblEmail.text = "Email: \(user.email ?? "")"
        cell.imgAvatar.load.request(with: user.avatar!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let view: UpdateCoreDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "updateVC") as! UpdateCoreDataViewController
        
        self.navigationController?.pushViewController(view, animated: true)
        
        let user = usersArray[indexPath.row]
        
        view.id = user.id
        view.first_name = user.first_name
        view.last_name = user.last_name
        view.email = user.email
        view.avatar = user.avatar
    }
    
    func saveUser(user: User){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context!)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(user.id, forKey: "id")
        newUser.setValue(user.first_name, forKey: "first_name")
        newUser.setValue(user.last_name, forKey: "last_name")
        newUser.setValue(user.email, forKey: "email")
        newUser.setValue(user.avatar, forKey: "avatar")
        
        do {
            try context?.save()
            print("saved successfully")
        } catch {
            print("save failed")
        }
    }
    
    func userExists(id: Int) -> Bool{
        
        var exists: Bool = false
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.predicate = NSPredicate(format: "id =  %d", id)
        
        do {
            let users = try context?.fetch(request)
            exists = users!.count == 0 ? false : true
            
            return exists
        } catch{
            print("Fetch failed")
        }
        return exists
    }
    
    func getUsers(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            let users = try context?.fetch(request)
            for user in users! {
                let userToSave = User()
                userToSave.id = (user as AnyObject).value(forKey: "id") as? Int
                userToSave.first_name = (user as AnyObject).value(forKey: "first_name") as? String
                userToSave.last_name = (user as AnyObject).value(forKey: "last_name") as? String
                userToSave.email = (user as AnyObject).value(forKey: "email") as? String
                userToSave.avatar = (user as AnyObject).value(forKey: "avatar") as? String
                usersArray.append(userToSave)
            }
        } catch{
            print("Fetch failed")
        }
    }
    
    
    func deleteUser(id: Int){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let users = try context?.fetch(request)
            for user in users!{
                context!.delete(user as! NSManagedObject)
            }
            try context?.save()
            print("Deleted")
        } catch{
            print("Delete failed")
        }
    }
    
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: Notification.Name("deleteUser"), object: nil)
    }
    @objc func handleNotification(notification: Notification){
        let id = (notification.userInfo?["id"] as? String)!
        let idInt = Int(id)
        
        deleteUser(id: idInt!)
        usersArray = []
        getUsers()
        self.tblUsers.reloadData()
    }
}
