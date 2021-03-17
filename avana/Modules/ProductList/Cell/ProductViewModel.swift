//
//  ProductViewModel.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation

struct ProductViewModel {

    private var product: Product

    init(product: Product) {
        self.product = product
    }

    var image: URL {
        return URL(string: product.image)!
    }

    var name: String {
        return product.name
    }

    var price: String {
        return String(format: "$%.02f", product.price)
    }

    var description: String {
        return product.description
    }
}
