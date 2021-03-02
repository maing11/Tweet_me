//
//  RegistrationController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    // MARK: Properties
    
    private let ImagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action:#selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        
        return view
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        
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
    
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Username")
        
        return tf
    }()
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributeButton("Already have an account ?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
        
    }()
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        
    }
    
    //MARK: - Selectors
    
    @objc func handleAddProfilePhoto() {
        //        navigationController?.popViewController(animated: true)
        print("...")
        ImagePicker.sourceType = .photoLibrary
        present(ImagePicker, animated: true, completion: nil)
        
    }
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            print("Debug: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username  = usernameTextField.text?.lowercased() else {return}
        
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials){(error, ref) in
//            print("DEBUG: sign up successful..")
//            print("DEBUG: Handle update user interface here")
            guard let windown = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else {return}
            
            guard let tab = windown.rootViewController as? MainTapController else {return}
            
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
        
    @objc func handleShowLogin(){
            navigationController?.popViewController( animated: true)
        }
        //MARK: - Helpers
        
        
        func configureUI() {
            view.backgroundColor = .twitterBlue
            
            view.addSubview(plusPhotoButton)
            plusPhotoButton.translatesAutoresizingMaskIntoConstraints = false
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 128).isActive = true
            plusPhotoButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
            //        plusPhotoButton.centerX(inView: view,topAnchor: view.safeAreaLayoutGuide.topAnchor)
            //        plusPhotoButton.setDimensions(width: 128, height: 128)
            //
            let stack = UIStackView(arrangedSubviews:[emailContainerView,
                                                      passwordContainerView,
                                                      fullnameContainerView,
                                                      userNameContainerView,
                                                      registrationButton])
            stack.axis = .vertical
            stack.spacing = 20
            stack.distribution = .fillEqually
            view.addSubview(stack)
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor,constant: 32).isActive = true
            stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 32).isActive = true
            stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -32).isActive = true
            
            // stack.anchor( top: logoImageView.bottomAnchor, left: view.leftAnchor,  right: view.rightAnchor, paddingTop: 16, paddingLeft:32,paddingRight:32 )
            
            view.addSubview(alreadyHaveAccountButton)
            alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
            alreadyHaveAccountButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40).isActive = true
            alreadyHaveAccountButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40).isActive = true
            alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
        }
        
    }
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate
    extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let profileImage = info[.editedImage] as? UIImage else {return}
            self.profileImage = profileImage
            
            plusPhotoButton.layer.cornerRadius = 128/2
            plusPhotoButton.layer.masksToBounds = true // fit circle image view
            plusPhotoButton.imageView?.contentMode = .scaleAspectFill
            plusPhotoButton.imageView?.clipsToBounds = true
            plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            plusPhotoButton.layer.borderWidth = 3
            
            self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
            dismiss(animated: true, completion: nil)
        }
    }
