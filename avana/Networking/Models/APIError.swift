//
//  APIError.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Moya

struct APIError: LocalizedError {
    let statusCode: Int
    let error: String

    var errorDescription: String? {
        return NSLocalizedString(error, comment: "default error")
    }

    static func from(response: Response) -> APIError? {
        guard let decodedError = try? response.map(RailsError.self) else {
            return nil
        }
        return APIError(statusCode: response.statusCode, error: decodedError.error ?? "Unknown Error")
    }
}

struct RailsError: Decodable {
    let error: String?

    enum CodingKeys: String, CodingKey {
        case error = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try? values.decode(String.self, forKey: .error)
    }
}
