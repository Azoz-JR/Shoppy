//
//  UserViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 17/01/2024.
//

import Foundation

final class UserViewModel {
    var currentUser: DBUser?
    
    init(currentUser: DBUser? = nil) {
        self.currentUser = currentUser
        
        getCurrentUser()
    }
    
    func getCurrentUser() {
        Task {
            currentUser = await UserManager.shared.getCurrentUser()
        }
    }
}
