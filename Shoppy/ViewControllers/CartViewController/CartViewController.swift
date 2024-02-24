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
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet var noItemsLabel: UILabel!
    
    var cartViewModel: CartViewModel
    var userViewModel: UserViewModel
    var cartProducts: [ItemModel] = []
    let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    init(cartViewModel: CartViewModel, userViewModel: UserViewModel) {
        self.cartViewModel = cartViewModel
        self.userViewModel = userViewModel
        
        super.init(nibName: "CartView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Cart"
        
        configView()
        bindToViewModel()
        setUpTableView()
        configureNotifications()
        setUpProgressView()
        
        refresh()
    }
    
    func configView() {
        couponTextField.delegate = self
        applyButton.isEnabled = false
        checkoutContainer.round(20)
        couponContainer.round(10)
        checkoutButton.round(20)
        
        //Refresh View
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        tableView.refreshControl = refreshControl
        
        checkoutButton.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyPromoCodeTapped), for: .touchUpInside)
        
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
        
        subtotalLabel.text = "\(cartViewModel.subTotal)$"
        discountLabel.text = "-\(cartViewModel.discount)"
        totalLabel.text = "\(cartViewModel.total)$"
        checkoutButton.isEnabled = !cartProducts.isEmpty
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
        
        
        cartViewModel.error.subscribe { [weak self] error in
            self?.show(error: error)
        }
        .disposed(by: disposeBag)
        
        cartViewModel.cartCount.addObserver { [weak self] count in
            guard let count else {
                return
            }
            
            self?.updateCheckoutButton(count: count)
        }
        
        cartViewModel.checkoutDone.subscribe(onNext: { [weak self] isDone in
            if isDone {
                DispatchQueue.mainAsyncIfNeeded {
                    self?.removePromoCode()
                }
            }
        })
        .disposed(by: disposeBag)

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle text changes here
        if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            cartViewModel.couponText = newText
            applyButton.isEnabled = !cartViewModel.couponText.isEmpty
        }
        
        return true
    }
    
    @objc func proceedTapped() {
        let vc = CheckoutViewController(cartViewModel: cartViewModel, userViewModel: userViewModel)
        show(vc, sender: self)
    }
    
    @objc func applyPromoCodeTapped() {
        // Check if there's a promo code already applied
        if cartViewModel.isPromoCodeApplied {
            removePromoCode()
            return
        }
        
        showProgressView()
        
        Task {
            do {
                try await cartViewModel.applyPromoCode(code: cartViewModel.couponText) { [weak self] error in
                    self?.hideProgressView()
                    if let error {
                        self?.showError(title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.mainAsyncIfNeeded {
                        self?.showRemoveButton()
                        self?.updateUI()
                    }
                }
            } catch {
                hideProgressView()
                showError(title: "Error Applying Promo Code", message: error.localizedDescription)
            }
        }
    }
    
    func removePromoCode() {
        couponTextField.text = ""
        showApplyButton()
        updateUI()
    }
    
    func showApplyButton() {
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        applyButton.tintColor = .label
        applyButton.isEnabled = false
        couponTextField.text = ""
        couponTextField.isEnabled = true
        cartViewModel.isPromoCodeApplied = false
    }
    
    func showRemoveButton() {
        applyButton.setTitle("Remove", for: .normal)
        applyButton.tintColor = .systemRed
        couponTextField.isEnabled = false
        cartViewModel.isPromoCodeApplied = true
    }
    
    func showProgressView() {
        DispatchQueue.mainAsyncIfNeeded {
            self.progressView.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
        
    }
    
    func hideProgressView() {
        DispatchQueue.mainAsyncIfNeeded {
            self.progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func updateCheckoutButton(count: Int) {
        guard cartProducts.isEmpty == false else {
            checkoutButton.setTitle("Proceed to Buy", for: .normal)
            return
        }
                
        if count == 1 {
            checkoutButton.setTitle("Proceed to Buy (1 item)", for: .normal)
        } else {
            checkoutButton.setTitle("Proceed to Buy (\(count) items)", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
