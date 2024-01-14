//
//  ProgressView.swift
//  Shoppy
//
//  Created by Azoz Salah on 14/01/2024.
//

import UIKit

class ProgressView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentMode = .center
        
        // Set background color and corner radius
        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 20.0

        //Add border
        addBorder(color: .lightGray.withAlphaComponent(0.2), width: 1)

        // Add label
//        addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        // Add activity indicator
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func startAnimating() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }

    func setLabelText(_ text: String) {
        label.text = text
    }
}
