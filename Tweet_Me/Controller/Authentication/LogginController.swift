//
//  LogginController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit

class LoginController: UIViewController {
    // MARK: Properties
    
    //MARK: Lifecycle
    
    private let logoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TweetmeLogo")
        return iv
        
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        //        let view = UIView()
        //        view.backgroundColor = .red
        //        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        //        let view = UIView()
        //        view.backgroundColor = .yellow
        //        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //
        return view
    }()
    
    
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
        
        
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributeButton("Don't have an account ?"," Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                return
            }
        
        }
    }
    @objc func handleShowSignUp() {
        print("-- ")
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    //MARK: - Helpers
    
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        // logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        // logoImageView.setDimensions(width: 156, height: 156 )
        //
        let stack = UIStackView(arrangedSubviews:[emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 32).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -32).isActive = true
        // stack.anchor( top: logoImageView.bottomAnchor, left: view.leftAnchor,  right: view.rightAnchor, paddingTop: 16, paddingLeft:32,paddingRight:32 )
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        dontHaveAccountButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40).isActive = true
        dontHaveAccountButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40).isActive = true
        dontHaveAccountButton.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
    }
}
