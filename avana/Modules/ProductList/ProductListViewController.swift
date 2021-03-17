//
//  ProductListViewController.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll

class ProductListViewController: UIViewController {

    fileprivate let viewModel: ProductListViewModel
    fileprivate let router: ProductListRouter
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    fileprivate var page = 1

    init(withViewModel viewModel: ProductListViewModel, router: ProductListRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
        setupViews()
        setupLayout()
    }
}

// MARK: Setup
private extension ProductListViewController {

    func setupViews() {
        viewModel.getProduct(page: page)

        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self

        setupInfiniteScroll()
    }

    func setupInfiniteScroll() {
        let landing = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        let spiner: UIActivityIndicatorView = UIActivityIndicatorView(frame: landing.frame)
        spiner.color = .gray
        spiner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        spiner.startAnimating()
        landing.addSubview(spiner)
        tableView.infiniteScrollIndicatorView = landing
        tableView.addInfiniteScroll { [weak self] (_) in
            self?.loadNextPage()
        }
    }

    func setupLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Our Products"
    }

    func setupRx() {
        viewModel.products?.drive(onNext: { [weak self] _ in
            self?.tableView.finishInfiniteScroll()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }

    func loadNextPage() {
        page += 1
        if page == 4 {
            page = 1
        }
        viewModel.getProduct(page: page)
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        if let viewModel = viewModel.viewModelForProduct(index: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel.selectedProduct(index: indexPath.row) {
            router.navigateToDetail(viewModel: viewModel)
        }
    }

}
