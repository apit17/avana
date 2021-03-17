//
//  ProductTableViewCell.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        productImage.layer.cornerRadius = 6
    }

    func configure(viewModel: ProductViewModel) {
        productImage.setImage(with: viewModel.image)
        productNameLabel.text = viewModel.name
        productPriceLabel.text = viewModel.price
        productDescriptionLabel.text = viewModel.description
    }
}
