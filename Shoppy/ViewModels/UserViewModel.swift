//
//  UserViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 17/01/2024.
//

import RxRelay
import Foundation
import RxSwift


final class UserViewModel {
    private let userSubject = BehaviorSubject<DBUser?>(value: nil)
    private let userAddresses = BehaviorRelay<[Address]>(value: [])
    private let currentSelectedAddressRelay = BehaviorRelay<Address?>(value: nil)
    
    var currentUser: Observable<DBUser?> {
        userSubject.asObservable()
    }
    
    var addresses: Observable<[Address]> {
        userAddresses.asObservable()
    }
    
    var selectedAddress: Observable<Address?> {
        currentSelectedAddressRelay.asObservable()
    }
    
    var currentSelectedAddress: Address? {
        currentSelectedAddressRelay.value
    }
    
    init() {
        getCurrentUser()
    }
    
    
    func getCurrentUser() {
        Task {
            let currentUser = await UserManager.shared.getCurrentUser()
            userSubject.onNext(currentUser)
        }
    }
    
    func uploadImage(image: Data, completion: @escaping (Error?) -> Void) {
        Task(priority: .background) {
            do {
                guard let userId = try userSubject.value()?.userId else {
                    await MainActor.run {
                        completion(URLError(.badURL))
                    }
                    return
                }
                
                try await UserManager.shared.updateUserProfilePicture(userId: userId, picture: image)
                
                getCurrentUser()
                
                await MainActor.run {
                    completion(nil)
                }
                
            } catch {
                await MainActor.run {
                    completion(error)
                }
            }
        }
    }
    
    func addAddress(address: Address) {
        let addresses = userAddresses.value + [address]
        
        userAddresses.accept(addresses)
        selectAddress(address: address)
    }
    
    func selectAddress(address: Address) {
        currentSelectedAddressRelay.accept(address)
    }

}
