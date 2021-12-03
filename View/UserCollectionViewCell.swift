//
//  UserCollectionViewCell.swift
//  boostudy
//

import UIKit
import SDWebImage

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    static let identifier = "UserCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "UserCollectionViewCell", bundle: nil)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.collectinoViewImage(imageView: userImageView, view: self.contentView)
        userNameLabel.collectionUserNameLabel(label: userNameLabel, view: self.contentView, imageView: userImageView)
    }
    
    func configure(userImageViewString:String,userNameLabelString:String){
        userImageView.sd_setImage(with: URL(string: userImageViewString), completed: nil)
        userNameLabel.text = userNameLabelString
    }
    
}
