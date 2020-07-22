import UIKit

class TeamCell: UITableViewCell {
    
    var TeamDelegate: teamDelegate!
    
    var teamObj: Team!


    @IBOutlet weak var lblTeam: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        

        
    }
    
    
}
