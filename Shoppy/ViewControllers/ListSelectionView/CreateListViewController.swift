//
//  CreateListViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/12/2023.
//

import UIKit

class CreateListViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var createListButton: UIButton!
    
    var listsViewModel: ListsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        createListButton.isEnabled = false
        createListButton.round()
        createListButton.addTarget(self, action: #selector(createList), for: .touchUpInside)
        textField.becomeFirstResponder()
    }
    
    @objc func createList() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        let list = List(name: text, items: [])
        listsViewModel?.createList(list: list)
        showAlert(title: "\(list.name) created successfully", dismiss: true)
        textField.resignFirstResponder()
    }
    
    // MARK: - TextField Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle text changes here
        if let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            createListButton.isEnabled = !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        return true
    }

}
