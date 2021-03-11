//
//  NotificationCell.swift
//  Tweet_Me
//
//  Created by mai ng on 3/9/21.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTappProfileImage(_ cell: NotificationCell)
    func didTappFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    // MARK : - Properties
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        

        let tap =  UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled  = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerY(inView: self)
        stack.leftAnchor.constraint(equalTo: leftAnchor,constant: 12).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.widthAnchor.constraint(equalToConstant: 92).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        followButton.layer.cornerRadius = 32/2
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selector
    @objc func handleProfileImageTapped(){
        delegate?.didTappProfileImage(self)
//        print("123456789")
    }
    
    @objc func handleFollowTapped() {
        delegate?.didTappFollow(self)
    }
    
    
    // MARK: - Helper
    
    func configure() {
        guard let notification = notification  else {return}
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        
        
        followButton.isHidden = viewModel.shouldHideFollowButoon
        followButton.setTitle(viewModel.folllowButtonText, for: .normal)
    }
    
    
}


