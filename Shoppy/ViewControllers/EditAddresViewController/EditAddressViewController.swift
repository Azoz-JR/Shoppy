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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configView()

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
        bindToViewModel()
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
    
    func setupSelectedAddress() {
        guard let selectedAddress else {
            return
        }
        
        viewModel.setupSelectedAddress()
        nameTextField.text = selectedAddress.name
        phoneTextField.text = selectedAddress.phone
        streetTextField.text = selectedAddress.street
        buildingTextField.text = selectedAddress.building
        floorTextField.text = selectedAddress.floor
        areaTextField.text = selectedAddress.area
        nearestLandmarkTextField.text = selectedAddress.landmark
    }
    
    func bindToViewModel() {
        setupSelectedLocation()
        
        viewModel.error.subscribe(onNext: { [weak self] error in
            self?.show(error: error)
        })
        .disposed(by: disposeBag)
    }
    
    func configTextFieldViews() {
        useAddressButton.round(20)
        nameTextField.addBorderAndPadding()
        phoneTextField.addBorderAndPadding()
        streetTextField.addBorderAndPadding()
        buildingTextField.addBorderAndPadding()
        floorTextField.addBorderAndPadding()
        areaTextField.addBorderAndPadding()
        nearestLandmarkTextField.addBorderAndPadding()
    }
    
    func setUpNameTextFields() {
        nameTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.name = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpPhoneTextField() {
        phoneTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.phone = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setupSelectedLocation() {
        viewModel.selectedLocationRelay.asObservable().subscribe(onNext: { [weak self] location in
            guard let location else {
                self?.selectedLocationLabel.isHidden = true
                return
            }
            
            self?.selectedLocationLabel.isHidden = false
            self?.selectedLocationLabel.text = location.placemark?.text
            self?.updateLocationButton()
        }
        )
        .disposed(by: disposeBag)
        
    }
    
    func setUpStreetTextField() {
        streetTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.street = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpBuildingTextField() {
        buildingTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.building = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpFloorTextField() {
        floorTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.floor = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpAreaTextField() {
        areaTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.area = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpLandmarkTextField() {
        nearestLandmarkTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.viewModel.landmark = text ?? ""
            }
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
                    self?.navigationController?.popViewController(animated: true)
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
    
    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }

}



