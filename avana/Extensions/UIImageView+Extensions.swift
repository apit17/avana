//
//  UIImageView+Extensions.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(with url: URL) {
        kf.setImage(with: url, placeholder: UIImage(named: "img_default"))
    }
}
