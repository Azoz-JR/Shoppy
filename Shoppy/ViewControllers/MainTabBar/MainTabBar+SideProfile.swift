//
//  MainTabBar+SideProfile.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/01/2024.
//

import UIKit

extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func bindToUser() {
        userViewModel.currentUser.subscribe { [weak self] user in
            guard let user else {
                return
            }
            
            DispatchQueue.mainAsyncIfNeeded {
                self?.sideProfileView.configure(with: user)
            }
        }
        .disposed(by: disposeBag)

    }
    
    func configureSideProfile() {
        sideProfileView.tapHandler = { [weak self] in
            self?.showProfile()
        }
        
        sideProfileView.imagePickerHandler = { [weak self] in
            self?.configureImagePicker()
        }
    }
    
    @objc func showProfile() {
        if !isProfileVisible {
            UIView.animate(withDuration: 0.5) {
                self.sideProfileView.frame.origin.x = 0
                //self.view.frame.origin.x = self.view.frame.width * 0.9
                //self.view.setNeedsLayout()
                self.isProfileVisible = true
            }
        } else {
            hideProfile()
            self.isProfileVisible = false
        }
    }
    
    private func hideProfile() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x = 0
            self.sideProfileView.frame.origin.x = -self.view.frame.maxX
            self.view.setNeedsLayout()
        }
    }
    
    func configureImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    func imageSelected(image: UIImage) {
        sideProfileView.showProgressView()
        
        sideProfileView.imageView.image = image
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            sideProfileView.hideProgressView()
            return
        }
        
        userViewModel.uploadImage(image: jpegData) { [weak self] error in
            self?.sideProfileView.hideProgressView()
            
            if let error {
                self?.show(error: error)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true) { [weak self] in
            self?.imageSelected(image: image)
        }
    }
    

    
}
