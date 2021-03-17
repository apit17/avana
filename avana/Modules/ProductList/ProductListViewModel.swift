//
//  ProductListViewModel.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/16/21.
//

import RxSwift
import RxCocoa

class ProductListViewModel {

    fileprivate let service: ProductService
    fileprivate let disposeBag = DisposeBag()

    fileprivate let productsSubject = BehaviorRelay<[Product]>(value: [])
    var products: Driver<[Product]>? {
        return productsSubject.asDriver()
    }

    var numberOfProducts: Int {
        return productsSubject.value.count
    }

    init(service: ProductService) {
        self.service = service
    }
}

extension ProductListViewModel {

    func getProduct(page: Int) {
        service.getProduct(page: page)
            .subscribe(onNext: { [weak self] products in
                guard let strongSelf = self else { return }
                let newProducts = strongSelf.productsSubject.value + products
                strongSelf.productsSubject.accept(newProducts)
            }, onError: { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.productsSubject.accept(strongSelf.productsSubject.value)
            })
            .disposed(by: disposeBag)
    }

    func viewModelForProduct(index: Int) -> ProductViewModel? {
        guard index < productsSubject.value.count else {
            return nil
        }
        return ProductViewModel(product: productsSubject.value[index])
    }

    func selectedProduct(index: Int) -> ProductDetailViewModel? {
        guard index < productsSubject.value.count else {
            return nil
        }
        return ProductDetailViewModel(product: productsSubject.value[index])
    }
}
