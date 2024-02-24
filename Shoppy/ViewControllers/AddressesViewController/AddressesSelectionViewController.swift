//
//  AddressesSelectionViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import RxSwift
import UIKit

class AddressesSelectionViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noAddressesView: UIView!
    
    var userViewModel: UserViewModel
    var addresses: [Address] = []
    var selectedAddress: Address?
    var disposeBag = DisposeBag()
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        
        super.init(nibName: "AddressesSelectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a delivery address"
        navigationItem.backButtonDisplayMode = .minimal

        setupTableView()
        setUpProgressView()
        bindToUserViewModel()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    func bindToUserViewModel() {
        userViewModel.addresses.subscribe(onNext: { [weak self] addresses in
            self?.addresses = addresses
            self?.reloadTableView()
            self?.noAddressesView.isHidden = !addresses.isEmpty
        })
        .disposed(by: disposeBag)
        
        userViewModel.selectedAddress.subscribe(onNext: { [weak self] address in
            self?.selectedAddress = address
            self?.reloadTableView()
        })
        .disposed(by: disposeBag)
    }
    
    func selectAddress(address: Address) {
        showProgressView()
        Task {
            do {
                try await userViewModel.selectAddress(address: address)
                
                hideProgressView()
            } catch {
                hideProgressView()
                show(error: error)
            }
        }
    }
    
    func editAddress(address: Address) {
        let vc = EditAddressViewController(userViewModel: userViewModel, selectedAddress: address)
        show(vc, sender: self)
    }
    
    @objc func addAddressTapped() {
        let vc = EditAddressViewController(userViewModel: userViewModel)
        show(vc, sender: self)
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
        
    }
    
    func showProgressView() {
        DispatchQueue.mainAsyncIfNeeded {
            self.progressView.isHidden = false
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

}
