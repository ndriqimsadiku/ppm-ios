
import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnDelete(_ sender: Any) {
        print("clicked")
        let id = String(lblID.text!.dropFirst(4))
        NotificationCenter.default.post(name: Notification.Name("deleteUser"), object: nil, userInfo: ["id": id])
    }
}
