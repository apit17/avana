//
//  ProductService.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Moya
import RxSwift

class ProductService: BaseApiService<ProductResource> {

    static let shared = ProductService()

    func getProduct(page: Int) -> Observable<[Product]> {
        return request(for: .getProduct(page: page), at: "products")
            .map { (activities, _) in
                return activities
            }
    }
}
