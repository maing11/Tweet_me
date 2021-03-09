//
//  TweetController.swift
//  Tweet_Me
//
//  Created by mai ng on 3/5/21.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    private let  tweet: Tweet
    private var actionSheetLaucher: ActionSheetLaucher!
    
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    
    // MARK: - Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLaucher = ActionSheetLaucher(user: user)
        actionSheetLaucher.delegate = self
        actionSheetLaucher.show()
    }
    
    
    // MARK: - API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) {replies in
            self.replies = replies
        }
    }

}


// MARK: - UICollectionViewDataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = replies[indexPath.row]
        
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension TweetController{
override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
    
    header.tweet = tweet
    header.delegate = self
    return header
}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}


// MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    func showActionSheet( ) {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser :tweet.user)

        } else {
            // Make this API call to figure out whether  or not our user is followed and then initialize this ActionSheetLaucher with the correct user property
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { [self]
                (isFollowed) in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
                
            }
        }
    }
}

// MARK: - ActionSheetLaucherDelegate

extension TweetController: ActionSheetLaucherDelegate {
    func didSelect(option: ActionSheetOptions) {
//        print("DEBUG: Option in controller is  \(option.description)")
        switch option{
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did follow user  \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did unfollow user  \(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
        case .delete:
            print("DEBUG: Delete tweet")
        
        }
    }

}
