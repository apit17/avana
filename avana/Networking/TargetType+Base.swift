//
//  TargetType+Base.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Moya

// MARK: TargetType base configuration
extension TargetType {

    var baseURL: URL {
        let baseUrlString = "https://private-87af1-avana2.apiary-mock.com/"
        return URL(string: baseUrlString)!
    }

    var sampleData: Data { return Data() }
}
