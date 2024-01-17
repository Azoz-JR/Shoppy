//
//  CartViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 13/12/2023.
//

import UIKit
import RxSwift


final class CartViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkoutContainer: UIView!
    @IBOutlet var couponContainer: UIView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var couponTextField: UITextField!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet var noItemsLabel: UILabel!
    
    var cartViewModel: CartViewModel
    var cartProducts: [ItemModel] = []
    var couponText: String = ""
    let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

    
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
        setUpProgressView()
        
        refresh()
    }
    
    func configView() {
        navigationController?.navigationBar.tintColor = .navBarTint
        couponTextField.delegate = self
        applyButton.isEnabled = false
        checkoutContainer.round(20)
        couponContainer.round(10)
        checkoutButton.round(20)
        
        //Refresh View
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        tableView.refreshControl = refreshControl
        
        updateUI()
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
        
    }
    
    @objc func refresh() {
        cartViewModel.getCart() { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        
    }
    
    func updateUI() {
        if cartProducts.isEmpty {
            noItemsLabel.isHidden = false
        } else {
            noItemsLabel.isHidden = true
        }
        
        subtotalLabel.text = "\(cartViewModel.total)$"
        totalLabel.text = "\(cartViewModel.total)$"
        checkoutButton.isEnabled = !cartProducts.isEmpty
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        reloadTableView()
    }
    
    func bindToViewModel() {
        cartViewModel.cartProducts.subscribe { [weak self] products in
            guard let self = self else {
                return
            }
            self.cartProducts = products
            self.updateUI()
        }
        .disposed(by: disposeBag)
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
        showProgressView()
        
        Task {
            do {
                try await cartViewModel.placeOrder() { [weak self] in
                    self?.cartViewModel.clearCart()
                    self?.hideProgressView()
                    
                    self?.showOrederConfirmationMessage()
                }
                
            } catch {
                print(error.localizedDescription)
                showError(title: "Checkout failed", message: error.localizedDescription)
                hideProgressView()
            }
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
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y -= offsetY
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offsetY = keyboardSize.height
            if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }
    
    func showProgressView() {
        progressView.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideProgressView() {
        progressView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
