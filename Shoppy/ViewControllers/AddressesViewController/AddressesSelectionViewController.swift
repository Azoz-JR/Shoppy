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
    
    var userViewModel: UserViewModel
    var addresses: [Address] = []
    var selectedAddress: Address?
    var disposeBag = DisposeBag()
    
    
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

        setupTableView()
        bindToUserViewModel()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    func bindToUserViewModel() {
        userViewModel.addresses.subscribe(onNext: { [weak self] addresses in
            self?.addresses = addresses
            self?.reloadTableView()
        })
        .disposed(by: disposeBag)
        
        userViewModel.selectedAddress.subscribe(onNext: { [weak self] address in
            self?.selectedAddress = address
            self?.reloadTableView()
        })
        .disposed(by: disposeBag)
    }
    
    func selectAddress(address: Address) {
        userViewModel.selectAddress(address: address)
    }
    
    func editAddress(address: Address) {
        let vc = EditAddressViewController(userViewModel: userViewModel, selectedAddress: address)
        show(vc, sender: self)
    }
    
    @objc func addAddressTapped() {
        let vc = EditAddressViewController(userViewModel: userViewModel)
        show(vc, sender: self)
    }

}
