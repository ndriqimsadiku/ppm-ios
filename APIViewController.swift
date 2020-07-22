import UIKit
import ImageLoader

class APIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblUsers: UITableView!
    
    var usersArray: [User] = []
    var totalPages: Int = 1
    var currentPage: Int = 1
    
    @IBOutlet weak var btnNextPage: UIButton!
    @IBOutlet weak var btnPreviousPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "API"
        getUsers(page: currentPage)
        setupTable()
        
    }
    
    func getUsers(page: Int){
        UserService.getUsers(page: page) { (success, users, error, tPages) in
            if(success){
                self.totalPages = tPages!
                print(self.totalPages)
                if let newUserArray = users {
                    self.usersArray = newUserArray
                    self.tblUsers.reloadData()
                    self.setupButtons()
                }
            }
        }
    }
    
    func setupButtons(){
        if(currentPage == 1){
            btnPreviousPage.isEnabled = false
        }else{
            btnPreviousPage.isEnabled = true
        }
        
        if(currentPage == totalPages){
            btnNextPage.isEnabled = false
        }else{
            btnNextPage.isEnabled = true
        }
    }
    
    func setupTable(){
        tblUsers.delegate = self
        tblUsers.dataSource = self
        tblUsers.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
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
    
    @IBAction func btnNextPage(_ sender: Any) {
        currentPage = currentPage + 1
        setupButtons()
        getUsers(page: currentPage)
    }
    @IBAction func btnPreviousPage(_ sender: Any) {
        currentPage = currentPage - 1
        setupButtons()
        getUsers(page: currentPage)
    }
}
