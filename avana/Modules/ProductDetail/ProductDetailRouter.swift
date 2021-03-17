//
//  ProductDetailRouter.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import Foundation

class ProductDetailRouter {
    weak var viewController: ProductDetailViewController?

    func navigateToLogin() {
        let vc = LoginBuilder.viewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true, completion: nil)
    }

    func navigateToCheckout(product: Product) {
        let vc = CheckoutBuilder.viewController(product: product)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
