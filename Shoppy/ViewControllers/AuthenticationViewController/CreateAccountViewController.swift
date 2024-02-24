//
//  CreateAccountViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 16/01/2024.
//
import RxSwift
import RxCocoa
import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    let disposeBag = DisposeBag()
    var email = ""
    var password = ""
    var confirmPassword = ""
    var firstName = ""
    var lastName = ""
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true

        configTextFieldView()
        setUpNamesTextFields()
        setUpEmailTextField()
        setUpPasswordTextField()
        setUpSignUpButton()
        setUpSignInButton()
        setUpProgressView()
    }
    
    func configTextFieldView() {
        firstNameTextField.addBorderAndPadding()
        lastNameTextField.addBorderAndPadding()
        emailTextField.addBorderAndPadding()
        passwordTextField.addBorderAndPadding()
        confirmPasswordTextField.addBorderAndPadding()
    }
    
    func setUpEmailTextField() {
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
    
    func setUpNamesTextFields() {
        firstNameTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.firstName = text ?? ""
            }
            .disposed(by: disposeBag)
        
        lastNameTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.lastName = text ?? ""
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
        
        confirmPasswordTextField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] text in
                self?.confirmPassword = text ?? ""
            }
            .disposed(by: disposeBag)
    }
    
    func setUpSignUpButton() {
        signUpButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] in
                self?.signUp()
            }
            .disposed(by: disposeBag)
    }
    
    func setUpSignInButton() {
        signInButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] in
                self?.popViewController()
            }
            .disposed(by: disposeBag)
    }
    
    func signUp() {
        guard checkEmailAndPassword() else {
            return
        }
        
        Task {
            showProgressView()
            do {
                let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                let user = DBUser(auth: authDataResult, firstName: firstName, lastName: lastName)
                try await UserManager.shared.createNewUser(user: user)
                
                hideProgressView()
                dismiss(animated: true)
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
    
    func checkEmailAndPassword() -> Bool {
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.showError(title: "Error", message: "You should enter first and last name")
            return false
        }
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.showError(title: "Wrong Email", message: "Enter a correct Email")
            return false
        }
        
        guard password == confirmPassword else {
            self.showError(title: "Error", message: "Confirmation password and password are not identical")
            return false
        }
        
        guard password.trimmingCharacters(in: .whitespacesAndNewlines).count > 6 else {
            self.showError(title: "Error", message: "Your password should be more than 6 letters")
            return false
        }
        
        return true
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
