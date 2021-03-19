//
//  ProductDetailViewController.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKCoreKit

class ProductDetailViewController: UIViewController {
    fileprivate let viewModel: ProductDetailViewModel
    fileprivate let router: ProductDetailRouter
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!

    init(withViewModel viewModel: ProductDetailViewModel, router: ProductDetailRouter) {
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
}

// MARK: Setup
private extension ProductDetailViewController {

    func setupViews() {
        productImage.setImage(with: viewModel.image)
        productNameLabel.text = viewModel.name
        productPriceLabel.text = viewModel.price
        productDescriptionLabel.text = viewModel.description
    }

    func setupLayout() {
        navigationItem.largeTitleDisplayMode = .never
        checkoutButton.layer.cornerRadius = 6
        checkoutButton.layer.borderWidth = 1.5
        checkoutButton.layer.borderColor = UIColor.systemGray6.cgColor
    }

    func setupRx() {
        checkoutButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.handleCheckout()
            }).disposed(by: disposeBag)
    }

    func handleCheckout() {
        router.navigateToCheckout(product: viewModel.product)
    }
}
