//
//  User.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import Foundation

struct User: Codable {
    var token: String?
    var name: String?
    var email: String?

    init(response: [String: String]?) {
        guard let result = response else {
            return
        }
        token = result["token"]
        name = result["name"]
        email = result["email"]
    }
}
