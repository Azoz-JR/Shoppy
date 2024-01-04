//
//  CartViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 13/12/2023.
//

import UIKit

final class CartViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkoutContainer: UIView!
    @IBOutlet var couponContainer: UIView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var couponTextField: UITextField!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    
    var productsViewModel: ProductsViewModel
    var ordersViewModel: OrdersViewModel
    
    var cartProducts: [ItemViewModel] = []
    var couponText: String = ""
    
    init(productsViewModel: ProductsViewModel, ordersViewModel: OrdersViewModel) {
        self.productsViewModel = productsViewModel
        self.ordersViewModel = ordersViewModel
        
        super.init(nibName: "CartView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUpTableView()
        configView()
    }
    
    func configView() {
        couponTextField.delegate = self
        applyButton.isEnabled = false
        checkoutContainer.round(20)
        couponContainer.round(10)
        checkoutButton.round(20)
        
        updateUI()
    }
    
    func updateUI() {
        subtotalLabel.text = "\(productsViewModel.total)$"
        totalLabel.text = "\(productsViewModel.total)$"
        checkoutButton.isEnabled = !cartProducts.isEmpty
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        reloadTableView()
    }
    
    func bindViewModel() {
        productsViewModel.cartProducts.addObserver { [weak self] products in
            guard let self = self, let products = products else {
                return
            }
            self.cartProducts = products
            self.updateUI()
        }
    }
    
    // MARK: TextField Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle text changes here
        if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            couponText = newText
            applyButton.isEnabled = !couponText.isEmpty
        }
        
        return true
    }
    
    @objc func checkoutTapped() {
        let order = Order(id: UUID(), items: cartProducts, price: productsViewModel.total, date: Date.now)
        ordersViewModel.placeOrder(order: order) { [weak self] _ in
            self?.productsViewModel.clearCart()
            
            self?.showOrederConfirmationMessage()
        }
    }
    
}
