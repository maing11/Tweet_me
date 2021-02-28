//
//  FeedController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    
    var user: User? {
        // Use the user to set our profileImageUrl
        // When this function gets called WE know that the user is exist
        didSet{
            configureLeftBarButton()        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView  = UIImageView(image: UIImage(named: "tweetme_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        
       
    }
    
    func configureLeftBarButton(){
        //Guarantee Our User exist
        guard let user = user else{return}
        
        let profileImageView = UIImageView()
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        
        //Url pass same as our users profileImageUrl - Try to load our user profile
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)

    }
    
}
