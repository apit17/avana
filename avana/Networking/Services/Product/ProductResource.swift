//
//  ProductResource.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Moya

enum ProductResource: TargetType {

    case getProduct(page: Int)

    var path: String {
        switch self {
        case .getProduct(let page):
            return "product/list/\(page)"
        }
    }

    var headers: [String: String]? {
        return [
            HTTPHeader.accept.rawValue: "application/json",
            HTTPHeader.contentType.rawValue: "application/json"
        ]
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }
}
