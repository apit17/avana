//
//  ProductDetailViewModel.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import RxSwift

class ProductDetailViewModel {

    var product: Product

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

private extension ProductDetailViewModel {

}
