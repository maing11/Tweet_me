//
//  FeedController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    
    var user: User? {
        // Use the user to set our profileImageUrl
        // When this function gets called WE know that the user is exist
        didSet{configureLeftBarButton()  }
    }
    
    // Create level variable . We can access in tweets arrray any where insise of this class
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false

    }
    
    // MARK: - Selectors
    @objc func handleRefresh() {
        fetchTweets()
    }
    
    
    // MARK: - API
    
    func fetchTweets()  {
        collectionView.refreshControl?.beginRefreshing()
        
        //Using this tweet array that we got back from our data fetch, to populate collection view
        TweetService.shared.fetchTweets { (tweets) in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
            
//            self.tweets = tweets.sorted(by: { (tweet1, tweet2) -> Bool in
//                return tweet1.timestamp > tweet2.timestamp
//            })
//
            self.collectionView.refreshControl?.endRefreshing()

    }
}
    
    func checkIfUserLikedTweets() {
        // Get access to the index that you are one of each iteration of your for loop
        self.tweets.forEach { (tweet) in
            TweetService.shared.checkIfUserLikeTweet(tweet) { (didLike) in
                guard didLike == true else {return}
                // FIrst index allow us to get access to an index where a certain condition is met
                if let index = self.tweets.firstIndex(where: {$0.tweetID == tweet.tweetID}) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        //Register this Tweetcell and pass this reuse identifier
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        let imageView  = UIImageView(image: UIImage(named: "tweetme_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        navigationItem.titleView = imageView
        
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action:#selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
       
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


// MARK: UICollectionViewDelegate/DataSource


extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath)
        as! TweetCell
        
        cell.delegate = self
        // We use this indexPath to access the element we want from the tweets datasource array
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(controller, animated: true)
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}


//MARK: UICollectionViewDelegateFLowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
    
}
 

extension FeedController: TweetCellDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in

            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
   
    
    func handleLikeTapped(_ cell: TweetCell) {
        // Unwrap this guy so can pass it below
        guard let tweet = cell.tweet else {return }
        
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            // Update the object on the cell
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            // And set the likes property in the cell
            cell.tweet?.likes = likes
            
            //Only upload the notification if tweet is being liked
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
       
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTweetController(user: tweet.user, config:.reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true,completion: nil)
        
    }
    
 
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user )
        navigationController?.pushViewController(controller, animated: true)
    }
   
}

