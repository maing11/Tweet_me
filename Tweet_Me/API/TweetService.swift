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
        
        let ref = REF_TWEETS.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            //Update user-tweet structure after tweet upload completes
            guard let tweetID = ref.key else {return}
            REF_USER_TWEETS.child(uid).onDisconnectUpdateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
   
        
        
    }

    // This function should give us back an array of tweets
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
    
        REF_TWEETS.observe(.childAdded){(snapshot) in
            print("DEBUG: Snapshot is \(snapshot.value)")
            guard let dictionary = snapshot.value as? [String:Any] else {return}
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
            
        }
    }
    //This function to give use back an array of tweets
    // And use that to populate our user profile controller with that array -> Datatsourse
    func fetchTweet(forUser user: User, completion: @escaping([Tweet]) -> Void ) {
        
        var tweets = [Tweet]()
        
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { (snapshot) in
           
            let tweetID = snapshot.key
            // Get back Tweet structure and find TweetID and get all of the tweet data
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
              
                // Pass the uid in this func when we want fetch the user
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
}
