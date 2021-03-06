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
    
    private var selectedFilter : ProfileFilterOption = .tweets {
        didSet {
            collectionView.reloadData()
        }
    }
                    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
    }
//    {
//        didSet {
//            collectionView.reloadData()
//        }
//    }

    
    
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
        fetchLikedTweets()
        fetchReplies()
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
            self.collectionView.reloadData()
        }
    }
    
    // We not collectionView.reloadData() . Because func fetchTweets is the initial data fetch store
    // But func fetchLikedTweets()  is  the initially displayed list
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { (tweets) in
            self.likedTweets = tweets
        }
        
    }
    
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { (tweets) in
            self.replies = tweets
////
//            self.replies.forEach { (reply) in
//                print("DEBUG: Replyign to \(reply.replyingTo)")
//            }
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
            
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    
    
    //     MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        guard let tapHeight = tabBarController?.tabBar.frame.height  else {return}
        
        collectionView.contentInset.bottom = tapHeight
        
    }
    
}



extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(currentDataSource.count)

        return  currentDataSource.count


    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        
        return cell
    }
}

//  MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}




extension ProfileController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350
        )
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet:currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        
        return CGSize(width: view.frame.width, height: height )
    }
}


// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOption) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            
            // Set the delegate on the editProfileController
            controller.delegate = self
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: true, completion:  nil)
            return
        
        }
//        if user.isCurrentUser {
//            print("DEBUG: Show edit profile controller")
//            return
//        }
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

// MARK: - EditProfileControllerDelegate
extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        // Reset our user && reload the collectionview to update everything in collection view in the profle controller
        self.user = user
        print(user.bio)
        self.collectionView.reloadData()
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
