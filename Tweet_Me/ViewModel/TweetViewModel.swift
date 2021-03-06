//
//  TweetViewModel.swift
//  Tweet_Me
//
//  Created by mai ng on 3/1/21.
//

import Foundation
import UIKit


struct TweetViewModel {
    // MARK: Properties
    
    let tweet: Tweet
    let user: User
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    var timestamp: String {
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
        }

  //TweetController
    var usernameText: String {
        return "@\(user.username)"
    }
    
    
    var headTimeStamp: String {
        let formater = DateFormatter()
        formater.dateFormat = "h:mm: a ・ MM/dd/yyyy"
        
        return formater.string(from: tweet.timestamp)
    }
    
    var retweetsAttributingString: NSAttributedString? {
        return attributeText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributingString: NSAttributedString? {
        return attributeText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes:[.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: "・ \(timestamp)",attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    
    var likeButttonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUser = tweet.replyingTo else {return nil}
        return "→ replying to @\(replyingToUser)"
    }
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet){
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributeText(withValue value: Int,text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string:  "\(value)",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray]))
        
        return attributedTitle
    }
    
    
    // MARK: - Helpers
//    
    func size( forWidth width: CGFloat) -> CGSize {
      let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
       return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
}
 
