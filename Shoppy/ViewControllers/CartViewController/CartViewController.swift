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
    
    var cartViewModel: CartViewModel
    var ordersViewModel: OrdersViewModel?
    
    var cartProducts: [ItemViewModel] = []
    var couponText: String = ""
    
    init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        
        super.init(nibName: "CartView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        bindToViewModel()
        setUpTableView()
        configureNotifications()
    }
    
    func configView() {
        navigationController?.navigationBar.tintColor = .navBarTint
        couponTextField.delegate = self
        applyButton.isEnabled = false
        checkoutContainer.round(20)
        couponContainer.round(10)
        checkoutButton.round(20)
        
        updateUI()
    }
    
    func updateUI() {
        subtotalLabel.text = "\(cartViewModel.total)$"
        totalLabel.text = "\(cartViewModel.total)$"
        checkoutButton.isEnabled = !cartProducts.isEmpty
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        reloadTableView()
    }
    
    func bindToViewModel() {
        cartViewModel.cartProducts.addObserver { [weak self] products in
            guard let self = self, let products = products else {
                return
            }
            self.cartProducts = products
            self.updateUI()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle text changes here
        if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            couponText = newText
            applyButton.isEnabled = !couponText.isEmpty
        }
        
        return true
    }
    
    @objc func checkoutTapped() {
        let order = Order(id: UUID(), items: cartProducts, price: cartViewModel.total, date: Date.now)
        ordersViewModel?.placeOrder(order: order) { [weak self] _ in
            self?.cartViewModel.clearCart()
            
            self?.showOrederConfirmationMessage()
        }
    }
    
    // MARK: - Keyboard methods
    func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offsetY = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.checkoutContainer.frame.origin.y -= offsetY
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.checkoutContainer.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
