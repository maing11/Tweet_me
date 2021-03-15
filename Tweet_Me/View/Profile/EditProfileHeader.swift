//
//  EditProfileHeader.swift
//  Tweet_Me
//
//  Created by mai ng on 3/13/21.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}


class EditProfileHeader: UIView{
    
    // MARK: - Properties
    private let user: User
     weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderWidth = 3.0
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
       let button = UIButton()
        button.setTitle("Change Profile Photo", for:.normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .red
        
        
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.center(inView: self,yConstant: -16)
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.layer.cornerRadius = 100/2
        
        
        addSubview(changePhotoButton)
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        changePhotoButton.centerX(inView: self, topAnchor:profileImageView.bottomAnchor,paddingTop: 8 )
        
        profileImageView.sd_setImage(with: user.profileImageUrl)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
            }
    
    // MARK: - Selector
    
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    
    // MARK: - Helper
    
    
    
    
    
    
    
    
}
