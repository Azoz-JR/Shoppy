//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "me")
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Abdelaziz Salah"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(profilePicture)
        view.addSubview(nameLabel)
                
        NSLayoutConstraint.activate([
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profilePicture.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            profilePicture.heightAnchor.constraint(equalToConstant: 80),
            profilePicture.widthAnchor.constraint(equalToConstant: 80),
            
            nameLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20)
            
            
        ])
    }
    

    func parseData() {
        let fakeStoreDataURL = "https://fakestoreapi.com/products"
        
        // Use URLSession to make a request to the API
        if let url = URL(string: fakeStoreDataURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                do {
                    // Parse the JSON data
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
                    print(jsonObject)
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }.resume()
        }
    }

}
