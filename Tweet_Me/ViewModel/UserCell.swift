//
//  UserCell.swift
//  Tweet_Me
//
//  Created by mai ng on 3/4/21.
//

import UIKit


class UserCell: UITableViewCell {
    // MARK: - Properties
    var user: User? {
        didSet { configure()
            
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        return iv
    }()
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Full name"
        
        return label
    }()
    
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "username"
        
        return label
    }()
    
   // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        profileImageView.centerY(inView: self)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerY(inView: profileImageView)
        stack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    // MARK: - Helpers
    
    
    func configure() {
        
        guard let user = user else {
            return
        }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
