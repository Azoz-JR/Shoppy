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
        // Add pan gesture recognizer to the swipeable view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)

        
        sideProfileView.tapHandler = { [weak self] in
            self?.resetSwipeableViewPosition()
        }
        
        sideProfileView.imagePickerHandler = { [weak self] in
            self?.configureImagePicker()
        }
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        if (sideProfileView.frame.origin.x == 0 && translation.x > 0) || (sideProfileView.frame.maxX == 0 && translation.x < 0) {
            return
        }
        
        switch recognizer.state {
        case .began:
            initialTranslationX = sideProfileView.transform.tx
            
        case .changed:
            sideProfileView.transform = CGAffineTransform(translationX: initialTranslationX + translation.x, y: 0)
            self.sideProfileView.mainContainer.backgroundColor = .clear
            
        case .ended:
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            // Check if the translation is beyond the threshold
            if sideProfileView.frame.maxX > swipeThreshold {
                // Perform the page swipe action (e.g., navigate to the next page)
                nextPageSwipe()
            } else {
                // Reset the swipeable view to its hidden position
                resetSwipeableViewPosition()
            }
            
        default:
            break
        }
        
    }
    
    func nextPageSwipe() {
        UIView.animate(withDuration: 0.3) {
            self.sideProfileView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        } completion: { _ in
            self.sideProfileView.mainContainer.backgroundColor = .black.withAlphaComponent(0.3)
        }
    }
    
    func resetSwipeableViewPosition() {
        // Reset the swipeable view to its hidden position
        UIView.animate(withDuration: 0.3) {
            self.sideProfileView.transform = .identity
            self.sideProfileView.mainContainer.backgroundColor = .clear
        }
    }
    
    @objc func showProfile() {
        nextPageSwipe()
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
