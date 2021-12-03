//
//  TermsTableViewCell.swift
//  boostudy
//

import UIKit

class TermsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var termsLabel: UILabel!
    
    static let idetifier = "TermsTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "TermsTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        termsLabel.termsLabel(label: termsLabel, item: self.contentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
