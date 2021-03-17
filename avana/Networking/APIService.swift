//
//  APIService.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import Foundation
import Moya
import RxSwift
import Alamofire

enum HTTPHeader: String {
    case token = "Authorization"
    case accept = "Accept"
    case contentType = "Content-Type"
}

struct StatusCode {
    static let unauthorized = 401
    static let notFound = 404
}

/**
 Public protocol that defines the minimum API that an APIService should expose.
 The APIService is the component in charge of handling al network request for
 an specific TargetType.
 Basic behaviour implemented using callbacks is provided by the BaseManager class.
 */
public protocol APIService {
    /// The associated TargetType of the Service.
    associatedtype ProviderType: TargetType
    /// The MoyaProvider instance used to make the network requests.
    var provider: MoyaProvider<ProviderType> { get }
    /// The JSON decoding strategy used for JSON Responses.
    var jsonDecoder: JSONDecoder { get }
}

/**
 Base ApiService class that implements generic behaviour to
 be extendended and used by subclassing it.
 The base service has an associated TargetType, this means
 that you should have **one and only one** manager for each TargetType.
 This base implementation provides helpers to make requests with automatic
 encoding if you provide a propper model as the expected result type.
 */
open class BaseApiService<T>: APIService where T: TargetType {
    public typealias ProviderType = T

    var disposeBag = DisposeBag()

    private var sharedProvider: MoyaProvider<T>!

    private var plugins: [PluginType] {
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        return [NetworkLoggerPlugin(configuration: configuration)]
    }

    private let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        configuration.urlCache = nil
        return Alamofire.Session(configuration: configuration)
    }()

    /**
     Default provider implementation as a singleton. It provides networking
     loggin out of the box and you can override it if you want to add more middleware.
     */
    open var provider: MoyaProvider<T> {
        guard let provider = sharedProvider else {
            sharedProvider = MoyaProvider<T>(session: manager, plugins: plugins)
            return sharedProvider
        }
        return provider
    }

    /**
     Default JSON decoder setup, uses the most common case of keyDecoding,
     converting from camel_case to snakeCase before attempting to match
     override this var if you need to customize your JSON decoder.
     */
    open var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }

    public required init () {}

    /**
     Makes a request to the provided target and tries to decode its response
     using the provided keyPath and return type and returning it as an Observable.
     - Parameters:
     - target: The TargetType used to make the request.
     - keyPath: The keypath used to decode from JSON (if passed nil, it will try to decode from the root).
     */
    open func request<T>(for target: ProviderType, at keyPath: String? = nil) -> Observable<(T, Response)> where T: Codable {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .flatMap { [weak self] response in
                let decodedValue = try response.map(T.self,
                                                    atKeyPath: keyPath,
                                                    using: self?.jsonDecoder ?? JSONDecoder(),
                                                    failsOnEmptyData: true)
                return .just((decodedValue, response))
            }
            .asObservable()
            .catchError { [weak self] error in
                guard let self = self else {
                    return Observable.error(error)
                }
                debugPrint(error)
                return Observable.error(self.handleError(with: error))
            }
    }

    private func handleError(with error: Error) -> Error {
        guard let moyaError = error as? MoyaError else {
            return error
        }
        switch moyaError {
        case .statusCode(let response):
            if response.statusCode == StatusCode.unauthorized {
                //        AppDelegate.shared.unexpectedLogout()
            }
            let decodedError = APIError.from(response: response)
            return decodedError ?? error
        case .stringMapping,
             .jsonMapping,
             .imageMapping:
            return error
        case .objectMapping(let mappingError, _):
            return mappingError
        case .encodableMapping(let error), .parameterEncoding(let error):
            return error
        case .underlying(let underlyingError, _):
            return underlyingError
        case .requestMapping:
            return error
        }
    }
}
