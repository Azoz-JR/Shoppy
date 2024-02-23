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
    
    var currentUserId: String? {
        try? userSubject.value()?.userId
    }
    
    var addresses: Observable<[Address]> {
        userAddresses.asObservable()
    }
    
    var selectedAddress: Observable<Address?> {
        currentSelectedAddressRelay.asObservable()
    }
    
    
    init() {
        try? getCurrentUser()
    }
    
    
    func getCurrentUser() throws {
        Task {
            do {
                let currentUser = try await UserManager.shared.getCurrentUser()
                userSubject.onNext(currentUser)
                
                try getUserAddresses()
            } catch {
                throw error
            }
        }
    }
    
    func uploadImage(image: Data, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                guard let userId = currentUserId else {
                    await MainActor.run {
                        completion(URLError(.badURL))
                    }
                    return
                }
                
                try await UserManager.shared.updateUserProfilePicture(userId: userId, picture: image)
                
                try getCurrentUser()
                
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
    
    func getUserAddresses() throws {
        Task {
            do {
                guard let currentUserId else {
                    return
                }
                
                let selectedAddress = try await UserManager.shared.getSelectedAddress(userId: currentUserId)
                let addresses = try await UserManager.shared.getAddresses(userId: currentUserId)
                
                await MainActor.run {
                    currentSelectedAddressRelay.accept(selectedAddress)
                    userAddresses.accept(addresses)
                }
                
            } catch {
                throw error
            }
        }
    }
    
    func getSelectedAddress() throws {
        Task {
            do {
                guard let currentUserId else {
                    return
                }
                                
                let selectedAddress = try await UserManager.shared.getSelectedAddress(userId: currentUserId)
                
                await MainActor.run {
                    currentSelectedAddressRelay.accept(selectedAddress)
                }
                
            } catch {
                throw error
            }
        }
    }
    
    func addAddress(address: Address) throws {
        Task {
            guard let currentUserId else {
                return
            }
            
            do {
                try UserManager.shared.createAddress(userId: currentUserId, address: address)
                try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
                
                try getUserAddresses()
            } catch {
                throw error
            }
        }
        
    }
    
    func selectAddress(address: Address) throws {
        Task {
            guard let currentUserId else {
                return
            }
            
            do {
                try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
                
                try getUserAddresses()
            } catch {
                throw error
            }
        }
    }
    
    func editAddress(address: Address) throws {
        Task {
            guard let currentUserId else {
                return
            }
            
            do {
                try UserManager.shared.updateAddress(userId: currentUserId, address: address)
                try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
                
                try getUserAddresses()
            } catch {
                throw error
            }
        }
    }

}
