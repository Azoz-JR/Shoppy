//
//  SideProfile.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/01/2024.
//

import UIKit

class SideProfile: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imagePickerButton: UIButton!
    
    let progressView = ProgressView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)))
    
    var tapHandler: (() -> Void)?
    var signOutHandler:(() -> Void)?
    var imagePickerHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let view = loadFromNib() {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        configureImage()
        setUpProgressView()
        
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        mainContainer.addGestureRecognizer(tapGesture)
        
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        imagePickerButton.addTarget(self, action: #selector(imagePickerTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "SideProfileView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    func configure(with user: DBUser) {
        imageView.image = user.profileImage
        nameLabel.text = user.fullName
    }
    
    func configureImage() {
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(systemName: "photo")
    }
    
    @objc func viewTapped() {
        tapHandler?()
    }
    
    @objc func signOutTapped() {
        signOutHandler?()
    }
    
    @objc func imagePickerTapped() {
        imagePickerHandler?()
    }
    
    func setUpProgressView() {
        addSubview(progressView)
        progressView.isHidden = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func showProgressView() {
        progressView.startAnimating()
        isUserInteractionEnabled = false
    }
    
    func hideProgressView() {
        progressView.stopAnimating()
        isUserInteractionEnabled = true
    }
    
}
