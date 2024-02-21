//
//  CheckoutViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/02/2024.
//

import UIKit

class CheckoutViewController: UIViewController {
    @IBOutlet var deliverView: UIView!
    @IBOutlet var deliveryDateLabel: UILabel!
    @IBOutlet var cashOnDeliveryView: UIView!
    @IBOutlet var cashViewSelectionMark: UIView!
    @IBOutlet var checkoutView: UIView!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    var cartViewModel: CartViewModel
    var userViewModel: UserViewModel

    
    init(cartViewModel: CartViewModel, userViewModel: UserViewModel) {
        self.cartViewModel = cartViewModel
        self.userViewModel = userViewModel
        
        super.init(nibName: "CheckoutViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a Payment method"
        
        navigationController?.navigationBar.applyShadow(cornerRadius: 5)
        
        cashOnDeliveryView.addBorder(color: .lightGray.withAlphaComponent(0.5), width: 1)
        cashOnDeliveryView.round(10)
        
        cashViewSelectionMark.selectPaymentMethod()
        
        setupGesture()
        
        checkoutView.addBorder(color: .lightGray.withAlphaComponent(0.5), width: 1)
        checkoutView.round(10)
        configCheckoutView()
        
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
    }
    
    func configCheckoutView() {
        subtotalLabel.text = "\(cartViewModel.subTotal)$"
        discountLabel.text = "-\(cartViewModel.discount)"
        totalLabel.text = "\(cartViewModel.total)$"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func checkoutTapped() {
        showProgressView()
        
        Task {
            do {
                try await cartViewModel.placeOrder()
                
                cartViewModel.clearCart()
                hideProgressView()
                showOrderConfirmationMessage()
                
            } catch {
                hideProgressView()
                showError(title: "Checkout failed", message: error.localizedDescription)
            }
        }
        
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        deliverView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let vc = AddressesSelectionViewController(userViewModel: userViewModel)
        
        show(vc, sender: self)
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
        
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
    
    func showOrderConfirmationMessage() {
        let alert = UIAlertController(title: "Thank you!", message: "Your order is submitted successfully!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
}
