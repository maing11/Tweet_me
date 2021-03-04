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
        fetchTweet()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false

    }
    
    //MARK: - API
    
    func fetchTweet()  {
        //Using this tweet array that we got back from our data fetch, to populate collection view
        TweetService.shared.fetchTweets { (tweets) in
            self.tweets = tweets
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
        
        
    }
    
}


//MARK: UICollectionViewDelegateFLowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}


extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user )
        navigationController?.pushViewController(controller, animated: true)
    }
   
}

