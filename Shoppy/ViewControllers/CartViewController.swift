//
//  CartViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 13/12/2023.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkoutContainer: UIView!
    @IBOutlet var couponContainer: UIView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var couponTextField: UITextField!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    var viewModel: CartViewModel
    var uniqueProducts: [ProductViewModel] = []
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.loadProducts()
        setUpTableView()
        configView()
    }
    
    func configView() {
        checkoutContainer.round(20)
        couponContainer.round(20)
        checkoutButton.round(20)
        
        updateUI()
    }
    
    func updateUI() {
        subtotalLabel.text = "\(viewModel.total)$"
        totalLabel.text = "\(viewModel.total)$"
    }
    
    func bindViewModel() {
        viewModel.cartProducts.bind { [weak self] products in
            guard let self = self, let products = products else {
                return
            }
            
            var uniqueSet = Set<ProductViewModel>()
            
            self.uniqueProducts = products.filter({ product in
                uniqueSet.insert(product).inserted
            })
            self.updateUI()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
