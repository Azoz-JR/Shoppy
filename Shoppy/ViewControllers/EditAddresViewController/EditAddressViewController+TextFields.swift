//
//  EditAddressViewController+TextFields.swift
//  Shoppy
//
//  Created by Azoz Salah on 24/02/2024.
//

import RxSwift
import UIKit

extension EditAddressViewController {
    func configTextFieldViews() {
        useAddressButton.round(5)
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
}
