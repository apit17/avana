//
//  CheckoutViewModel.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import RxSwift

enum CheckoutSection {
    case product, proof
}

class CheckoutViewModel {

    var product: Product?
    var sections: [CheckoutSection] = [.product, .proof]

    init(product: Product) {
        self.product = product
    }

    var customerName: String {
        let user = SessionManager.currentSession
        return "Your name: \(user?.name ?? "")\nYour email: \(user?.email ?? "")"
    }
}
