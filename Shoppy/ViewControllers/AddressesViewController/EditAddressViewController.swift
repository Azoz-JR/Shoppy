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
    
    var userViewModel: UserViewModel
    var selectedLocationRelay = BehaviorRelay<Location?>(value: nil)
    let disposeBag = DisposeBag()
    
    var name = ""
    var phone = ""
    var location = ""
    var street = ""
    var building = ""
    var floor = ""
    var area = ""
    var landmark = ""
    
    var selectedLocation: Location? {
        selectedLocationRelay.value
    }
    
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        
        super.init(nibName: "EditAddressViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an address"

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
        setupSelectedLocation()
    }
    
    func setUpNameTextFields() {
        nameTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.name = text ?? ""
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
                self?.phone = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setupSelectedLocation() {
        selectedLocationRelay.asObservable().subscribe(onNext: { [weak self] location in
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
                self?.street = text ?? ""
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
                self?.building = text ?? ""
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
                self?.floor = text ?? ""
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
                self?.area = text ?? ""
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
                self?.landmark = text ?? ""
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
                vc.locationRelay = self?.selectedLocationRelay
                vc.currentLocation = self?.selectedLocation
                
                self?.show(UINavigationController(rootViewController: vc), sender: self)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpUseAddressButton() {
        useAddressButton
            .rx
            .tap
            .bind { [weak self] in
                guard let self else {
                    self?.showError(title: "Address error", message: "The address's information isn't enough.")
                    return
                }
                
                guard isAcceptableAddress(), let placemark = selectedLocation?.placemark else {
                    self.showError(title: "Address error", message: "The address's information isn't enough.")
                    
                    return
                }
                
                let address = Address(name: name, phone: phone, street: street, building: building, floor: floor, area: area, city:  placemark.administrativeArea, country: placemark.country, location: selectedLocation)
                
                userViewModel.addAddress(address: address)
                navigationController?.popViewController(animated: true)
            }
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
    
    func isAcceptableAddress() -> Bool {
        guard !name.isEmpty, !phone.isEmpty, selectedLocation != nil, !street.isEmpty, !building.isEmpty, !floor.isEmpty else {
            return false
        }
        
        return true
    }
    
    func updateLocationButton() {
        if selectedLocation != nil {
            addLocationButton.setTitle("Edit", for: .normal)
        } else {
            addLocationButton.setTitle("Add location on map", for: .normal)
        }
    }

}
