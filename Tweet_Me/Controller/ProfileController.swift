//
//  ProfileController.swift
//  Tweet_Me
//
//  Created by mai ng on 3/1/21.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //     MARK : - Properties
    private var user: User
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //    MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //
    //    }
    
    
    //MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            
//            self.user.stats = stats
//            self.collectionView.reloadData()
            print("DEBUG: User has  \(stats.followers) followers")
            print("DEBUG: User is following \(stats.following) people")
        }
    }
    
    
    
    //     MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }
    
}


//  MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350
        )
        
    }
}


// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
//        print("DEBUG: User is followed is \(user.isFollowed) before button tap")
        
        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller")
            return
        }
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (ref, err) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
    
            }
            
        } else {
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user:self.user)
               
            }
        }
    }
    
    func handleDissmissal() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

//import UIKit
//
//
//private let reuseIdentifier = "TweetCell"
//
//class ProfileController : UIViewController {
//    var myCollectionView:UICollectionView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let view = UIView()
//        view.backgroundColor = .white
//        configureCollectionView()
//    }
//
//
//    func configureCollectionView() {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        myCollectionView?.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        myCollectionView?.backgroundColor = UIColor.white
//
//        myCollectionView?.dataSource = self
//        myCollectionView?.delegate = self
//
//        view.addSubview(myCollectionView ?? UICollectionView())
//
//        self.view = view
//
//
//    }
//}
//
//extension ProfileController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3 // How many cells to display
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
//        return myCell
//    }
//}
//
//extension ProfileController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 120)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//           return CGSize(width: view.frame.width, height: 300)
//
//       }
//}
//
