//
//  LoginBuilder.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit

struct LoginBuilder {

    static func viewController() -> UIViewController {
        let viewModel = LoginViewModel(service: LoginService.shared)
        let router = LoginRouter()
        let viewController = LoginViewController(withViewModel: viewModel, router: router)
        router.viewController = viewController

        return viewController
    }
}
