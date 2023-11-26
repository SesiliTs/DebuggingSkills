//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched()
    func productsAmountChanged()
}

class ProductsListViewModel {
    
    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [ProductModel]?
    var totalPrice: Double { products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} ?? 0 }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    
    func addProduct(at index: Int) {
        guard var product = products?[index] else { return }
        var changedAmount = product.selectedAmount ?? 0
        changedAmount += 1
        if changedAmount <= product.stock {
            updateSelectedAmount(product: &product, newValue: changedAmount)
            products?[index] = product
            delegate?.productsAmountChanged()
        }
        
    }
    
    func removeProduct(at index: Int) {
        guard var product = products?[index] else { return }
        var changedAmount = product.selectedAmount ?? 0
        changedAmount -= 1
        if changedAmount >= 0 {
            updateSelectedAmount(product: &product, newValue: changedAmount)
            products?[index] = product
            delegate?.productsAmountChanged()
        }
    }
    
    func updateSelectedAmount(product: inout ProductModel, newValue: Int) {
        product.selectedAmount = newValue
    }
}
