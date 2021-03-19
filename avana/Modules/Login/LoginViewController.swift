//
//  LoginViewController.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit

class LoginViewController: UIViewController {
    fileprivate let viewModel: LoginViewModel
    fileprivate let router: LoginRouter
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var greetLabel: UILabel!
    init(withViewModel viewModel: LoginViewModel, router: LoginRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        setupRx()
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Setup
private extension LoginViewController {

    func setupViews() {
        let greet = SessionManager.validSession ? "Hi, \(SessionManager.currentSession?.name ?? "There")": "You need to login first"
        greetLabel.text = greet
        loginFacebookButton.isHidden = SessionManager.validSession
    }

    func setupLayout() {

    }

    func setupRx() {
        loginFacebookButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel.loginFacebook(controller: self)
            }).disposed(by: disposeBag)

        viewModel.loginResult
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
