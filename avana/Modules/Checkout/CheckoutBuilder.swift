//
//  CheckoutBuilder.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit

struct CheckoutBuilder {

    static func viewController(product: Product) -> UIViewController {
        let viewModel = CheckoutViewModel(product: product)
        let router = CheckoutRouter()
        let viewController = CheckoutViewController(withViewModel: viewModel, router: router)
        router.viewController = viewController

        return viewController
    }
}
