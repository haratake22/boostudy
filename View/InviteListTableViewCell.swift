//
//  InviteListTableViewCell.swift
//  boostudy
//

import UIKit
import SDWebImage

class InviteListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var inviteListImageVIew: UIImageView!
    @IBOutlet weak var inviteListNameLabel: UILabel!
    @IBOutlet weak var inviteListGenderLabel: UILabel!
    @IBOutlet weak var inviteListAgeLabel: UILabel!
    
    static let idetifier = "InviteListTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "InviteListTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        inviteListImageVIew.cellImageView(imageView: inviteListImageVIew, view: self.contentView)
        inviteListNameLabel.topCellLabel(label: inviteListNameLabel, topItem: self.contentView, leftItem: inviteListImageVIew)
        inviteListAgeLabel.cellLabel(label: inviteListAgeLabel, topItem: inviteListNameLabel as Any, leftItem: inviteListImageVIew)
        inviteListGenderLabel.cellLabel(label: inviteListGenderLabel, topItem: inviteListAgeLabel as Any, leftItem: inviteListImageVIew)
        // Initialization code
    }

    func configure(inviteListImageString:String,inviteListNameString:String,inviteListGenderString:String,inviteListAgeString:String){
        inviteListImageVIew.sd_setImage(with: URL(string: inviteListImageString), completed: nil)
        inviteListNameLabel.text = inviteListNameString
        inviteListAgeLabel.text = inviteListAgeString + "歳"
        inviteListGenderLabel.text = inviteListGenderString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
