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
    }
    
    func selectAddress(address: Address) {
        
    }
    
    func editAddress(address: Address) {
        
    }
    
    @objc func addAddressTapped() {
        let vc = EditAddressViewController(userViewModel: userViewModel)
        show(vc, sender: self)
    }

}
