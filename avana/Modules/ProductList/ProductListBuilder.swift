//
//  ProductListBuilder.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import UIKit

struct ProductListBuilder {

    static func viewController() -> UIViewController {
        let viewModel = ProductListViewModel(service: ProductService.shared)
        let router = ProductListRouter()
        let viewController = ProductListViewController(withViewModel: viewModel, router: router)
        router.viewController = viewController

        return viewController
    }
}
