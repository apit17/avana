//
//  ProductListRouter.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation

class ProductListRouter {
    weak var viewController: ProductListViewController?

    func navigateToDetail(viewModel: ProductDetailViewModel) {
        let vc = ProductDetailBuilder.viewController(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLogin() {
        let vc = LoginBuilder.viewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true, completion: nil)
    }
}
