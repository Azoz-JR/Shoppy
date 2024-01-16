//
//  RootViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 15/01/2024.
//

import FirebaseAuth
import UIKit

class RootViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        Task {
            do {
                try AuthenticationManager.shared.signOut()
            } catch {
                print(error.localizedDescription)
            }
        }

        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                let vc = MainTabBarController()
                vc.modalPresentationStyle = .fullScreen
                
                self?.present(vc, animated: true)
            } else {
                let vc = AuthenticationViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }

}
