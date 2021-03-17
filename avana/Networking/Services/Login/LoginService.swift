//
//  LoginService.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift

class LoginService {

    static let shared = LoginService()

    private let facebookResultSubject = PublishSubject<[String: String]>()
    var facebookResult: Observable<[String: String]> {
        return facebookResultSubject.asObservable()
    }

    func loginFacebook(viewController: UIViewController) {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] (result, error) in
            guard let result = result else { return }

            if result.isCancelled {
                print("Facebook login cancelled")
            } else {
                if result.grantedPermissions.contains("email") {
                    GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { [weak self] (_, result, error) in

                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let result = result as? [String: String] {
                                var newResult = result
                                newResult["token"] = AccessToken.current?.tokenString
                                self?.facebookResultSubject.onNext(newResult)
                                manager.logOut()
                            }
                        }
                    })
                }
            }
        }
    }

}
