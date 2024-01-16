//
//  AuthenticationViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 15/01/2024.
//

import RxSwift
import RxCocoa
import UIKit

class AuthenticationViewController: UIViewController {
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    let disposeBag = DisposeBag()
    var email = ""
    var password = ""
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTextFieldView()
        setUpProgressView()
        setUpEmailTextFields()
        setUpPasswordTextField()
        setUpSignInButton()
        setUpCreateAccountButton()
        
    }
    
    func setUpEmailTextFields() {
        emailTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.email = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpPasswordTextField() {
        passwordTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.password = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpSignInButton() {
        signInButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self else { return }
                
                signIn(email: self.email, password: self.password)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpCreateAccountButton() {
        createAccountButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self else { return }
                
                let vc = CreateAccountViewController()
                self.show(vc, sender: self)
            }
            .disposed(by: disposeBag)
    }
    
    func configTextFieldView() {
        emailTextField.addBorder(color: .label, width: 1.5)
        emailTextField.round(15)
        emailTextField.setLeftPaddingPoints(10)
        emailTextField.setRightPaddingPoints(1)
        
        passwordTextField.addBorder(color: .label, width: 1.5)
        passwordTextField.round(15)
        passwordTextField.setLeftPaddingPoints(10)
        passwordTextField.setRightPaddingPoints(1)
    }
    
    func signIn(email: String, password: String) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, password.trimmingCharacters(in: .whitespacesAndNewlines).count > 4 else {
            return
        }
        
        Task {
            progressView.startAnimating()
            do {
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                
                progressView.stopAnimating()
            } catch {
                print(error.localizedDescription)
                progressView.stopAnimating()
            }
        }
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
    }

}
