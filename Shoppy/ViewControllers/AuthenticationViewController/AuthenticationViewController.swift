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
        configGoogleButton()
        
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
        emailTextField.addBorderAndPadding()
        
        passwordTextField.addBorderAndPadding()
    }
    
    func configGoogleButton() {
        googleButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] in
                guard let self else { return }
                
                self.signInGoogle()
            }
            .disposed(by: disposeBag)
    }
    
    @MainActor
    func signInGoogle() {
        Task {
            do {
                let helper = SignInGoogleHelper()
                let tokens = try await helper.signIn(presenter: self)
                
                showProgressView()
                
                let result = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
                hideProgressView()
                
                // Check if this is the first signning in with this Google account
                guard result.user.metadata.creationDate == result.user.metadata.lastSignInDate else {
                    hideProgressView()
                    return
                }
                
                let user = DBUser(auth: result.auth, firstName: tokens.name)
                try await UserManager.shared.createNewUser(user: user)
            } catch {
                hideProgressView()
                show(error: error)
            }
        }
    }

    
    func signIn(email: String, password: String) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, password.trimmingCharacters(in: .whitespacesAndNewlines).count > 4 else {
            return
        }
        
        Task {
            showProgressView()
            do {
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                
                hideProgressView()
            } catch {
                hideProgressView()
                show(error: error)
            }
        }
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
    }
    
    func showProgressView() {
        progressView.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideProgressView() {
        progressView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
