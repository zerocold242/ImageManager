//
//  ViewController.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import UIKit

enum LoginModel {
    case signUp
    case logIn
    case changePassword
}

class LoginViewController: UIViewController {
    
    private var authMode: LoginModel
    private var firstPass: String?//первый ввод пароля
    private var secondPass: String?//подтверждение пароля
    
    init(authMode: LoginModel) {
        self.authMode = authMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var indicatorActivity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var passTextField: CustomTextField = {
        let passTextField = CustomTextField(font: .systemFont(ofSize: 16),
                                            textColor: .black,
                                            backgroundColor: .systemGray5,
                                            placeholder: "   EnterPassword")
        passTextField.isSecureTextEntry = true
        return passTextField
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(title: nil, titleColor: .white, actionTap: { [weak self] in
            
            switch self?.authMode {
            case .signUp:
                self?.signUp()
            case .logIn:
                self?.logIn()
            case .changePassword:
                self?.signUp()
            case .none:
                break
            }
        })
        return button
    }()
    
    //кнопка cancel появляется только в режиме смены пароля, скрывает экран редактирования пароля
    private lazy var cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isHidden = true
        cancel.backgroundColor = .white
        cancel.setTitle("Cancel", for: .normal)
        cancel.clipsToBounds = true
        cancel.setTitleColor(.red, for: .normal)
        cancel.setTitleColor(.systemGray, for: .highlighted)
        cancel.addTarget(self, action: #selector(cancelPush), for: .touchUpInside)
        return cancel
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func loginButtonTitle() {
        switch self.authMode {
        case .signUp:
            self.loginButton.setTitle("Create password", for: .normal)
        case .logIn:
            self.loginButton.setTitle("Enter password", for: .normal)
        case .changePassword:
            self.loginButton.setTitle("Save new password", for: .normal)
            self.isModalInPresentation = true
            self.cancelButton.isHidden = false
        }
    }
    
    //метод для перехода из авторизации  в документы через координатор
    private func presentDocuments() {
        view.window?.rootViewController = DocumentsCoordinator.shared.createTabBarController()
        view.window?.makeKeyAndVisible()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(passTextField)
        view.addSubview(loginButton)
        view.addSubview(logoView)
        view.addSubview(indicatorActivity)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            
            indicatorActivity.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            indicatorActivity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            passTextField.heightAnchor.constraint(equalToConstant: 50),
            passTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: passTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            cancelButton.leadingAnchor.constraint(equalTo: passTextField.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor),
            
            logoView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 60),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 200),
            logoView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func cancelPush() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //метод сохранения нового пароля с подтверждением
    @objc private func signUp() {
        self.indicatorActivity.isHidden = false
        self.indicatorActivity.startAnimating()
        guard let password = passTextField.text else { return }
        if !password.isEmpty, password.count >= 4 {
            self.cancelButton.isHidden = true
            let pass = UserDefaults.standard.bool(forKey: "Pass")
            //первый ввод пароля
            if pass == false {
                firstPass = passTextField.text
                DispatchQueue.main.async {
                    self.loginButton.setTitle("Confirm Password", for: .normal)
                    self.passTextField.text = ""
                    UserDefaults.standard.set(true, forKey: "Pass")
                }
                print("First password \(String(describing: firstPass))")
                //подтверждение пароля
            } else {
                self.indicatorActivity.isHidden = false
                self.indicatorActivity.startAnimating()
                secondPass = passTextField.text
                print("Second password \(String(describing: secondPass))")
                if firstPass == secondPass {
                    self.loginButton.isEnabled = false
                    //в случае корректного подтверждения удаляем пароль из UserDefaults и сохраняем в keychain
                    UserDefaults.standard.removeObject(forKey: "Pass")
                    LoginInspector.shared.signUp(password: password) {
                        self.presentDocuments()
                        if (UserDefaults.standard.objectIsForced(forKey: "ChangePass")) == true {
                            self.dismiss(animated: true, completion: {
                                UserDefaults.standard.removeObject(forKey: "ChangePass")})
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if (UserDefaults.standard.objectIsForced(forKey: "ChangePass")) == true {
                            self.loginButton.setTitle("Save new password", for: .normal)
                            self.passTextField.text = ""
                        }
                    }
                    UserDefaults.standard.removeObject(forKey: "Pass")
                    WarningAlert.defaultAlert.showAlert(showAlertIn: self, message: "Passwords don't match")
                    self.indicatorActivity.isHidden = true
                    self.loginButton.setTitle("Save new password", for: .normal)
                    self.passTextField.text = ""
                }
            }
        } else if !password.isEmpty, password.count < 4 {
            WarningAlert.defaultAlert.showAlert(showAlertIn: self, message: "Password must be at least 4 characters")
            self.indicatorActivity.isHidden = true
            passTextField.text = ""
        } else if password.isEmpty {
            WarningAlert.defaultAlert.showAlert(showAlertIn: self, message: "Enter Password")
            self.indicatorActivity.isHidden = false
        }
    }
    
    @objc private func logIn() {
            self.indicatorActivity.isHidden = false
            self.indicatorActivity.startAnimating()
        if let password = passTextField.text, !password.isEmpty {
            guard let pass = passTextField.text else { return }
            LoginInspector.shared.logIn(password: pass) { [self] result in
                if result {
                    self.presentDocuments()
                    print("LogIn")
                } else {
                    WarningAlert.defaultAlert.showAlert(showAlertIn: self, message: "Wrong Password")
                    self.passTextField.text = ""
                }
            }
        } else {
            WarningAlert.defaultAlert.showAlert(showAlertIn: self, message: "Enter password")
        }
    }
        
    //скрытие клавиатуры по клику
    private func gesture() {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        gesture.addTarget(self, action: #selector(self.gestureAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func gestureAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonTitle()
        setUpView()
        gesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        passTextField.text = .none
    }
}
