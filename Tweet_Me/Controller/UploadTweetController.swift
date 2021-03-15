//
//  UploadTweetController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/28/21.
//

import UIKit


class UploadTweetController: UIViewController {
    // MARK: - Propertie
    
    // Makr this level variable because We need to access it outside this intitialize
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    // lazy var because this config hasn't necessarily been set yet once we try to instantiate the viewModel with that config

    
    
    //Only load this button when we try to access it
    //  I'm not going to load it until you tell me I have to
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue

        return iv
    }()
    
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor  = UIColor.lightGray
        label.text = "replying to @pikachu"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    
    private let captionTextView = InputTextView()
    //MARK: - Lifecycle
    
    init(user: User,config: UploadTweetConfiguration) {
        // Use this user to populate our user interface with some data about that user
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    // Create custome initialize
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - Selectors
    @objc func handleCanceled(){
        dismiss(animated: true, completion: nil)

    }
    
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else{return}
        TweetService.shared.uploadTweet(caption:caption, type: config) { (error, ref) in
            print("DEBUG: - Tweet did upload to database")
            if let error = error {
                print("DEBUG: - Failed to upload tweet with error \(error.localizedDescription )")
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
                
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }        
    }
    //MARK - API
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        // Using Stack to add a bunhc of Subvies a lot easier
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
//        stack.alignment = .leading
        stack.spacing = 12
    
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
//        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:16).isActive = true
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)

        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeHolderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else {return}
        replyLabel.text = replyText
        
        
    }
    
//    func configureUIComponents() {
        
//    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCanceled))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
    }
}
