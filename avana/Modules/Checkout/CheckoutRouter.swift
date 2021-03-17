//
//  CheckoutRouter.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import Foundation

class CheckoutRouter {
    weak var viewController: CheckoutViewController?

    func dismiss() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
