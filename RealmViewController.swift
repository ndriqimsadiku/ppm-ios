import UIKit
import SQLite3

protocol teamDelegate{
    func getTeamsDel()
}

class RealmViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource , teamDelegate{
    
    func getTeamsDel() {
        delegateFunctions()
    }
    
    
    
    
    @IBOutlet weak var tblTeam: UITableView!
    var db: OpaquePointer?
    var fileUrl: URL!
    let firstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
    var teamsArray: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SQLITE"
        createDatabaseFile()
        openDatabase()
        getTeams()
        setupTable()
        readData()

    }

    func delegateFunctions(){
        print("You Think You deleted something")
    }
    
    func getTeams(){
        NbaService.getTeams { (success, teams, error) in
            if(success){
                if let newTeamArray = teams {
                    self.teamsArray = newTeamArray
                    self.tblTeam.reloadData()
                }
            }
            if(!self.firstLaunch){
                print("First")
                for t in self.teamsArray{
                    self.insertData(teamName: t.full_name!, city: t.city!)
                }
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            }else{
                print("Not First")
            }
            
        }
        
    }
    
    func setupTable(){
        tblTeam.delegate = self
        tblTeam.dataSource = self
        tblTeam.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "teamCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! TeamCell
        
        
        var openStatment: OpaquePointer?
        let openQuery="SELECT * FROM Team where id = \(indexPath.row)"

        // prepare
        if(sqlite3_prepare(db, openQuery, -1, &openStatment, nil) == SQLITE_OK){
            print("preparing read succes")
        }else{
            print("preparing read FAILED")
        }
        while(sqlite3_step(openStatment) == SQLITE_ROW){
            let id = sqlite3_column_int(openStatment, 0)
            let teamName = String(cString: sqlite3_column_text(openStatment, 1))
            let city = String(cString: sqlite3_column_text(openStatment, 2))

            cell.lblTeam.text = teamName
            cell.lblCity.text = city

        }
        
        return cell
    }
    
    //SQLITE
    
    func createDatabaseFile(){
        fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Teams.sqlite")
    }
    func openDatabase(){
        if(sqlite3_open(fileUrl.path, &db) == SQLITE_OK){
            print("openDatabase succes")
            createTable()
        }else{
            print("openDatabse error")
        }
    }
    func createTable(){
        let query = "CREATE TABLE IF NOT EXISTS Team (id INTEGER PRIMARY KEY AUTOINCREMENT, teamName TEXT, city String)"
        if(sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK){
            print("Create Table Succes")
        }else{
            print("Create Table FAil")
        }
    }
    
    func insertData(teamName: String, city: String){
        var statment: OpaquePointer?
        
        let query = "INSERT INTO Team (teamName,city) VALUES (?,?)"
        
        // prepare
        if(sqlite3_prepare(db, query, -1, &statment, nil) == SQLITE_OK){
//            print("preparing insert succes")
        }else{
//            print("preparing insert FAILED")
        }
        //bin
        if(sqlite3_bind_text(statment, 1, "\(teamName)", -1, nil) == SQLITE_OK){
//            print("name bind succes")
        }else{
//            print("name binf FAIL")
        }
        if(sqlite3_bind_text(statment,2,"\(city)",-1,nil) == SQLITE_OK){
//            print("city bind succes")
        }else{
//            print("city bind FAIL")
        }
        //excecute
        if(sqlite3_step(statment) == SQLITE_DONE){
//            print("insert Employee Success")
        }else{
//            print("insert Employe FAILED")
        }
    }
    
    func readData(){
        var statment: OpaquePointer?
        let query="SELECT * FROM Team"
        
        // prepare
        if(sqlite3_prepare(db, query, -1, &statment, nil) == SQLITE_OK){
//            print("preparing read succes")
        }else{
//            print("preparing read FAILED")
        }
        while(sqlite3_step(statment) == SQLITE_ROW){
            let id = sqlite3_column_int(statment, 0)
            let teamName = String(cString: sqlite3_column_text(statment, 1))
            let city = String(cString: sqlite3_column_text(statment, 2))
            
            print("id = \(id)")
            print("teamName = \(teamName)")
            print("city = \(city)")
        }
    }
    
    func update(teamName: String , id: Int) {
        
        let updateStatementString = "UPDATE Team SET teamName = '\(teamName)' WHERE id = \(id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func delete(id: Int) {
        
        let deleteStatementStirng = "DELETE FROM Team WHERE id = \(id);"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    
}
