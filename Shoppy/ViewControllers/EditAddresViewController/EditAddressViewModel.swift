//
//  EditAdressViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/02/2024.
//

import Foundation
import RxRelay
import RxSwift

class EditAddressViewModel {
    var userViewModel: UserViewModel
    var selectedAddress: Address?
    
    var name = ""
    var phone = ""
    var location = ""
    var street = ""
    var building = ""
    var floor = ""
    var area = ""
    var landmark = ""
    
    var selectedLocationRelay = BehaviorRelay<Location?>(value: nil)
    private var errorSubject = PublishSubject<AddressValidationError>()
    
    var error: Observable<AddressValidationError> {
        errorSubject.asObservable()
    }

    var selectedLocation: Location? {
        selectedLocationRelay.value
    }
    
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    
    func setupSelectedAddress() {
        if let selectedAddress {
            name = selectedAddress.name
            phone = selectedAddress.phone
            location = selectedAddress.location?.placemark?.text ?? ""
            street = selectedAddress.street
            building = selectedAddress.building
            floor = selectedAddress.floor
            area = selectedAddress.area
            landmark = selectedAddress.landmark ?? ""
            selectedLocationRelay.accept(selectedAddress.location)
        }
    }
    
    func useAddress(completion: @escaping () -> Void) {
        if let selectedAddress {
            // Edit Selected address
            editAddress(address: selectedAddress, completion: completion)
        } else {
            // Create a new address
            createAddress(completion: completion)
        }
    }
    
    private func createAddress(completion: @escaping () -> Void) {
        if let error = isUnAcceptableAddress() {
            errorSubject.onNext(error)
            return
        }
        
        let address = Address(name: name, phone: phone, street: street, building: building, floor: floor, area: area, landmark: landmark, location: selectedLocation)

        userViewModel.addAddress(address: address)
        completion()
    }
    
    private func editAddress(address: Address, completion: @escaping () -> Void) {
        if let error = isUnAcceptableAddress() {
            errorSubject.onNext(error)
            return
        }
        
        address.name = name
        address.phone = phone
        address.street = street
        address.building = building
        address.floor = floor
        address.area = area
        address.location = selectedLocation
        
        userViewModel.selectAddress(address: address)
        completion()
    }
    
    private func checkForEmptyTextFields() throws {
        if name.isEmpty {
            throw AddressValidationError.nameEmpty
        }
        if phone.isEmpty {
            throw AddressValidationError.phoneEmpty
        }
        if selectedLocation == nil {
            throw AddressValidationError.locationEmpty
        }
        if street.isEmpty {
            throw AddressValidationError.streetEmpty
        }
        if building.isEmpty {
            throw AddressValidationError.buildingEmpty
        }
        if floor.isEmpty {
            throw AddressValidationError.floorEmpty
        }
        if area.isEmpty {
            throw AddressValidationError.areaEmpty
        }
        if landmark.isEmpty {
            throw AddressValidationError.landmarkEmpty
        }
    }
    
    private func isUnAcceptableAddress() -> AddressValidationError? {
        do {
            try checkForEmptyTextFields()
            return nil
        } catch let error as AddressValidationError {
            return error
        } catch {
            return nil
        }
    }
}
