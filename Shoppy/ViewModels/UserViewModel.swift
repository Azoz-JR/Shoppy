//
//  UserViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 17/01/2024.
//

import RxRelay
import Foundation
import RxSwift


actor UserViewModel {
    private let userSubject = BehaviorSubject<DBUser?>(value: nil)
    private let userAddresses = BehaviorRelay<[Address]>(value: [])
    private let currentSelectedAddressRelay = BehaviorRelay<Address?>(value: nil)
    
    nonisolated var currentUser: Observable<DBUser?> {
        userSubject.asObservable()
    }
    
    nonisolated var currentUserId: String? {
        try? userSubject.value()?.userId
    }
    
    nonisolated var addresses: Observable<[Address]> {
        userAddresses.asObservable()
    }
    
    nonisolated var selectedAddress: Observable<Address?> {
        currentSelectedAddressRelay.asObservable()
    }
    
    
    init() {
        Task {
            try await getCurrentUser()
        }
    }
    
    
    func getCurrentUser() throws {
        Task {
            do {
                let currentUser = try await UserManager.shared.getCurrentUser()
                userSubject.onNext(currentUser)
                
                try await getUserAddresses()
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
    
    func getUserAddresses() async throws {
        guard let currentUserId else {
            return
        }
        
        let selectedAddress = try await UserManager.shared.getSelectedAddress(userId: currentUserId)
        let addresses = try await UserManager.shared.getAddresses(userId: currentUserId)
        
        await MainActor.run {
            currentSelectedAddressRelay.accept(selectedAddress)
            userAddresses.accept(addresses)
        }
    }
    
    func getSelectedAddress() throws {
        Task {
            guard let currentUserId else {
                return
            }
            
            let selectedAddress = try await UserManager.shared.getSelectedAddress(userId: currentUserId)
            
            await MainActor.run {
                currentSelectedAddressRelay.accept(selectedAddress)
            }
        }
    }
    
    func addAddress(address: Address) async throws {
        guard let currentUserId else {
            return
        }
        
        try UserManager.shared.createAddress(userId: currentUserId, address: address)
        try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
        
        try await getUserAddresses()
    }
    
    func selectAddress(address: Address) async throws {
        guard let currentUserId else {
            return
        }
        
        try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
        
        try await getUserAddresses()
    }
    
    func editAddress(address: Address) async throws {
        guard let currentUserId else {
            return
        }
            
        try UserManager.shared.updateAddress(userId: currentUserId, address: address)
        try UserManager.shared.setSelectedAddress(userId: currentUserId, address: address)
        
        try await getUserAddresses()

    }
    
    func deleteAddress(address: Address) async throws {
        guard let currentUserId else {
            return
        }
        
        try await UserManager.shared.deleteAddress(userId: currentUserId, address: address)
        
        try await getUserAddresses()
    }

}
