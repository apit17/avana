//
//  LoginViewModel.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import RxSwift

class LoginViewModel {
    fileprivate let disposeBag = DisposeBag()
    fileprivate let service: LoginService

    fileprivate let loginResultSubject = PublishSubject<[String: String]>()
    var loginResult: Observable<[String: String]> {
        return loginResultSubject.asObservable()
    }

    init(service: LoginService) {
        self.service = service
        setupRx()
    }

    func loginFacebook(controller: UIViewController) {
        service.loginFacebook(viewController: controller)
    }
}

// MARK: Setup
private extension LoginViewModel {

    func setupRx() {
        service.facebookResult.subscribe(onNext: { [weak self] result in
            SessionManager.currentSession = User(response: result)
            self?.loginResultSubject.onNext(result)
        }).disposed(by: disposeBag)
    }
}
