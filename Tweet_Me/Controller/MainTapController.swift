//
//  MainTapController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit
import Firebase

class MainTapController: UITabBarController {
    
    // Creat user variable and then once that variable gets set 
    var user: User? {
    // Pass this user from the MainTabController to FeedController
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController  else {return}
            //We get feed by looking at the navigationController , list of viewControllers and grab the first one
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
        }
    }
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        //Color customize
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionbuttonTapped), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    func fetchUser(){
        UserService.shared.fetchUser { (user) in
            self.user = user
        }
    }
    // Use this func to check and make sure user logged in
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewController()
            configureUI()
            fetchUser()

        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did log user out ?")
            
        } catch let error {
            print("DEBIG: Failed to sign in with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    
    @objc func actionbuttonTapped() {
        print("123")
    }
    
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -56).isActive = true
        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        //        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 14, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
        
    }
    func configureViewController() {
        let feed = FeedController()
        let nav1 = templateNotificationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        
        let explore = ExploreController()
        //        explore.tabBarItem.image = UIImage(named: "search_unselected")
        let nav2 = templateNotificationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        //        notifications.tabBarItem.image = UIImage(named:"search_unselected")
        let nav3 = templateNotificationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        
        let conversations = ConversationsController()
        let nav4 = templateNotificationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        
        
        viewControllers = [nav1, nav2,nav3,nav4]
    }
    
    func templateNotificationController(image: UIImage?,rootViewController:UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
        
    }
    
}
