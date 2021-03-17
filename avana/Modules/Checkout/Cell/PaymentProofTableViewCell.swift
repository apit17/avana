//
//  PaymentProofTableViewCell.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit

class PaymentProofTableViewCell: UITableViewCell {

    @IBOutlet weak var proofImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
