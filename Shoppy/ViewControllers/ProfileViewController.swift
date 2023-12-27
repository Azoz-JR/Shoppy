//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    var ordersViewModel: OrdersViewModel?
    
    let profileView = ProfileView()
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        
        guard let order = ordersViewModel?.orders.value?.first else {
            return
        }
        
        profileView.configureOrder(with: order)
    }

}
