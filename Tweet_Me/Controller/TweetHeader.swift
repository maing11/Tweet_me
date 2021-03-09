//
//  TweetHeader.swift
//  Tweet_Me
//
//  Created by mai ng on 3/5/21.
//

import UIKit

protocol  TweetHeaderDelegate:class {
    func showActionSheet()
}
class TweetHeader: UICollectionReusableView {

    //MARK: - Properties
    
    
    var tweet: Tweet?  {
        didSet{configure()
        }
    }
    
    weak var delegate:TweetHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
        
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = " Mie Ng"
        return label
        
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = " mieng11"
        return label
        
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Some test caption from mie for now kerb gksb gksbr g ksbe gese"
        return label
        
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM - 1/28/2020"
        return label
        
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetLabel = UILabel()

    private lazy var likesLabel = UILabel()

//
//
    
//    private lazy var retweetButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(handleRetweetsTapped), for: .touchUpInside)
//        return button
//
//    }()
//
//
//    private lazy var likesButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(handleLikesTapped), for: .touchUpInside)
//        return button
//
//    }()
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let diverder1 = UIView()
        diverder1.backgroundColor = .systemGroupedBackground
        view.addSubview(diverder1)
        diverder1.translatesAutoresizingMaskIntoConstraints = false
        diverder1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diverder1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        diverder1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        diverder1.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        let stack = UIStackView(arrangedSubviews: [retweetLabel,likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16).isActive = true
        

        let diverder2 = UIView()

        diverder2.backgroundColor = .systemGroupedBackground
        view.addSubview(diverder2)
        diverder2.translatesAutoresizingMaskIntoConstraints = false
        diverder2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        diverder2.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        diverder2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        diverder2.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
     return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = creatButon(withImage: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = creatButon(withImage: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button

    }()
    
    private lazy var likeButton: UIButton = {
        let button = creatButon(withImage: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button

    }()
    
    private lazy var shareButton: UIButton = {
        let button = creatButon(withImage: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button

    }()
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
//        labelStack.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [profileImageView  , labelStack])
        labelStack.spacing = 12
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
//        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 12).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor,constant: 20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true


        addSubview(optionButton)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.centerY(inView: stack)
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        
        addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        statsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        statsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        statsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let actionStats = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStats.spacing = 72

        addSubview(actionStats)
        actionStats.translatesAutoresizingMaskIntoConstraints = false
        actionStats.centerX(inView: self)
        actionStats.topAnchor.constraint(equalTo:statsView.bottomAnchor, constant: 16).isActive = true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper
    
    @objc func handleProfileImageTapped(){
        print("DEBUG: Go to user profile")
}
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    
    @objc func handleShareTapped() {
        
    }
    
    
//    @objc func handleRetweetsTapped(){
//
//    }
//
//    @objc func handleLikesTapped() {
//
//    }
    
    // MARK: - Helper
    
    func configure() {
        guard let tweet = tweet  else {return}
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headTimeStamp
        retweetLabel.attributedText = viewModel.retweetsAttributingString
        likesLabel.attributedText = viewModel.likesAttributingString
        
        
        
        
        
    }

    func creatButon(withImage imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return button

    }
    
    
   
}
