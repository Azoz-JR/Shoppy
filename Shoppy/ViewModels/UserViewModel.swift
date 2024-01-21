//
//  UserViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 17/01/2024.
//

import Foundation
import RxSwift


final class UserViewModel {
    private let userSubject = BehaviorSubject<DBUser?>(value: nil)
    
    var currentUser: Observable<DBUser?> {
        userSubject.asObservable()
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
                
                await MainActor.run {
                    completion(nil)
                }
                
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    completion(error)
                }
            }
        }
    }

}
