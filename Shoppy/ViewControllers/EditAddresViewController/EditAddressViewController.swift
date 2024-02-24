//
//  EditAddressViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import RxSwift
import RxRelay
import UIKit

class EditAddressViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var addLocationButton: UIButton!
    @IBOutlet var selectedLocationLabel: UILabel!
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var buildingTextField: UITextField!
    @IBOutlet var floorTextField: UITextField!
    @IBOutlet var areaTextField: UITextField!
    @IBOutlet var nearestLandmarkTextField: UITextField!
    @IBOutlet var useAddressButton: UIButton!
    
    var activeTextField: UITextField?
    
    let viewModel: EditAddressViewModel
    var userViewModel: UserViewModel
    var selectedAddress: Address?
    let disposeBag = DisposeBag()
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    
    init(userViewModel: UserViewModel, selectedAddress: Address? = nil) {
        self.userViewModel = userViewModel
        self.selectedAddress = selectedAddress
        self.viewModel = EditAddressViewModel(userViewModel: userViewModel)
        self.viewModel.selectedAddress = selectedAddress
        
        super.init(nibName: "EditAddressViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        setUpProgressView()
        setupNotifications()
        bindToViewModel()
        
        configTextFieldViews()
        setUpNameTextFields()
        setUpPhoneTextField()
        setUpStreetTextField()
        setUpBuildingTextField()
        setUpFloorTextField()
        setUpAreaTextField()
        setUpLandmarkTextField()
        setUpUseAddressButton()
        setUpAddLocationButton()
    }
    
    func configView() {
        if selectedAddress == nil {
            title = "Add an address"
            titleLabel.text = "Enter a new shipping address"
        } else {
            title = "Edit your address"
            titleLabel.text = "Edit your shipping address"
            setupSelectedAddress()
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupSelectedAddress() {
        guard let selectedAddress else {
            return
        }
        
        nameTextField.text = selectedAddress.name
        phoneTextField.text = selectedAddress.phone
        streetTextField.text = selectedAddress.street
        buildingTextField.text = selectedAddress.building
        floorTextField.text = selectedAddress.floor
        areaTextField.text = selectedAddress.area
        nearestLandmarkTextField.text = selectedAddress.landmark
        viewModel.selectedLocationRelay.accept(selectedAddress.location)
    }
    
    func bindToViewModel() {
        setupSelectedLocation()
        
        viewModel.error.subscribe(onNext: { [weak self] error in
            self?.showError(title: "Insufficient Address", message: error)
        })
        .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isLoading in
            if isLoading {
                self?.showProgressView()
            } else {
                self?.hideProgressView()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func setupSelectedLocation() {
        viewModel.selectedLocationRelay.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] location in
            guard let location else {
                self?.selectedLocationLabel.isHidden = true
                return
            }
            
            self?.selectedLocationLabel.isHidden = false
            self?.selectedLocationLabel.text = location.placemark?.text
            self?.updateLocationButton()
            self?.updateAddressFields()
        }
        )
        .disposed(by: disposeBag)
        
    }
    
    func setUpAddLocationButton() {
        addLocationButton
            .rx
            .tap
            .bind { [weak self] in
                let vc = MapViewController()
                vc.modalPresentationStyle = .pageSheet
                vc.locationRelay = self?.viewModel.selectedLocationRelay
                vc.currentLocation = self?.viewModel.selectedLocation
                
                self?.show(UINavigationController(rootViewController: vc), sender: self)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpUseAddressButton() {
        useAddressButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.useAddress {
                    self?.popViewController()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func updateLocationButton() {
        if viewModel.selectedLocation != nil {
            addLocationButton.setTitle("Edit", for: .normal)
        } else {
            addLocationButton.setTitle("Add location on map", for: .normal)
        }
    }
    
    func updateAddressFields() {
        guard let placemark = viewModel.selectedLocation?.placemark else {
            return
        }
        
        areaTextField.text = placemark.subLocality
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
    
    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
}
