//
//  ProductDetailBuilder.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit

struct ProductDetailBuilder {

    static func viewController(viewModel: ProductDetailViewModel) -> UIViewController {
        let router = ProductDetailRouter()
        let viewController = ProductDetailViewController(withViewModel: viewModel, router: router)
        router.viewController = viewController

        return viewController
    }
}
