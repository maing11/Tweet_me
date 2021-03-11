//
//  Notification.swift
//  Tweet_Me
//
//  Created by mai ng on 3/9/21.
//

import Foundation


enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}


struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, dictionary:[String: AnyObject]) {
        print(dictionary)
        self.user = user
//        self.tweet = tweet
//        tweet: Tweet?
        
//        self.tweetID =  dictionary["tweetID"] as? String ?? ""
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
