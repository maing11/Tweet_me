//
//  TweetService.swift
//  Tweet_Me
//
//  Created by mai ng on 2/28/21.
//

import Firebase

//Our upload Tweet function
struct TweetService {
    static let shared = TweetService()
    
    
    func uploadTweet(caption:String, completion: @escaping(Error?,DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //Cast this value as a dictionary
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweet": 0,
                      "caption": caption] as [String : Any]
        //childByAutoId  is going to just automatically generate this unique identifier for us
        REF_TWEETS.childByAutoId().updateChildValues(values,withCompletionBlock: completion)
        
        
    }

    // This function should give us back an array of tweets
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
    
        REF_TWEETS.observe(.childAdded){(snapshot) in
            print("DEBUG: Snapshot is \(snapshot.value)")
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            // We have to get this uid from dictionary
            guard let uid = dictionary["uid"] as? String else {return}
            // Access TweetID
            let tweetID = snapshot.key
            
            // Pass the uid in this func when we want fetch the user
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                           tweets.append(tweet)
                           completion(tweets)
                           
            }
            
            
//
        }
    }
}
