//
//  LaunchViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/01/2024.
//

import FirebaseAuth
import UIKit

class LaunchViewController: UIViewController {
    
    var count: Int = 2
    var animationStart = false
    
    var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "shoppy"))
        image.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        image.contentMode = .scaleToFill
        return image
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !animationStart {
            imageView.center = view.center
            animationStart = true
            DispatchQueue.main.async {
                self.animate()
            }
        }
    }
    
    private func animate() {
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        UIView.animate(withDuration: 0.5) {
            self.imageView.frame = CGRect(x: centerX - 90, y: centerY - 90, width: 180, height: 180)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.5) {
                    self.imageView.frame = CGRect(x: centerX - 60, y: centerY - 60, width: 120, height: 120)
                } completion: { done in
                    if done {
                        self.count -= 1
                        if self.count < 0 {
                            self.finalAnimation()
                        } else {
                            // Repeat Animation until count equals -1
                            self.animate()
                        }
                    }
                }
            }
        }
    }
    
    func finalAnimation() {
        let width = view.frame.width
        UIView.animate(withDuration: 0.5) {
            self.imageView.frame = CGRect(x: -width / 2, y: self.view.center.y - width, width: width * 2, height: width * 2)
            
            self.imageView.alpha = 0
        } completion: { done in
            if done {
                self.didFinishLaunching()
            }
        }
        
//        UIView.animate(withDuration: 0.5) {
//            self.imageView.alpha = 0
//        } completion: { done in
//            
//        }
    }
    
    func didFinishLaunching() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
                
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                sceneDelegate.window?.rootViewController = MainTabBarController()
            } else {
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: AuthenticationViewController())
            }
        }
    }

}
