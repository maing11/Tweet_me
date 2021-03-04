//
//  ProfileHeader.swift
//  Tweet_Me
//
//  Created by mai ng on 3/1/21.
//

import UIKit


protocol ProfileHeaderDelegate: class {
    func handleDissmissal()
}
class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    var user: User? {
        didSet{configure()}
    }
    
    weak var delegate : ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 42).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
        
        
    }()
    
    private lazy var editProfileImageEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
        
        
    }()
    
    private let fullnameLabel: UILabel  = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
        
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purpose  "
        return label
    }()
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
        
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Following"
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label

    }()
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Followers"

        
        let followTap = UITapGestureRecognizer(target: self, action:#selector( handleFollwersTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)

        return label

    }()
    
    
    
    
  
    // MARK: - LIfecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileImageEditButton)
        editProfileImageEditButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileImageEditButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        editProfileImageEditButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        editProfileImageEditButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editProfileImageEditButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        editProfileImageEditButton.layer.cornerRadius = 36/2
        
        let userDetailsStack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel,bioLabel])
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        
        addSubview(userDetailsStack)
        userDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        userDetailsStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        userDetailsStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        userDetailsStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.translatesAutoresizingMaskIntoConstraints = false
        followStack.topAnchor.constraint(equalTo: userDetailsStack.bottomAnchor, constant: 8).isActive = true
        followStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        followStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
    
        addSubview(filterBar)
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        filterBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        filterBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        filterBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        filterBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        addSubview(underLineView)
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        underLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //        underLineView.rightAnchor.constraint(equalTo: rightAnchor).isActive =  true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: frame.width / 3).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDissmissal()
    }
    
    @objc func handleEditProfileFollow() {
        
    }
    
    @objc func handleFollwersTap(){
        
    }
    
    @objc func handleFollowingTap(){}
    // MARK: - Helpers
    
    func configure() {
        guard let user = user else {return }
        let viewModel = ProfileHeaderViewModel(user: user)

        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        editProfileImageEditButton.setTitle((viewModel.actionButtonTitle), for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
        
    }
    
}


// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard  let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
        
        let xPosition = cell.frame.origin.x
        print(xPosition)
        UIView.animate(withDuration: 0.3){
            self.underLineView.frame.origin.x = xPosition
        }
    }
    
}
