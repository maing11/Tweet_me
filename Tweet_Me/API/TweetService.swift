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
    
    
    func uploadTweet(caption:String,type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //Cast this value as a dictionary
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweet": 0,
                      "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            
            REF_TWEETS.updateChildValues(values) { (err, ref) in
                //Update user-tweet structure after tweet upload completes
                guard let tweetID = ref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values, withCompletionBlock: completion)        }
        
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
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void ) {
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { (tweet) in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void ){
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
          
            // Pass the uid in this func when we want fetch the user
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
               completion(tweet)
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { (snapshot) in
            guard let dictionary  = snapshot.value as? [String: AnyObject] else {return}
            guard let uid = dictionary["uid"]  as? String else {return}
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user:user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
        
    }
    
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        // We going to the tweet struture finding tweetID , going to likes child and setting value of likes
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            //remove like data from Firebase(unlike tweet)
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                REEF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            //like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (err, ref) in
                REEF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
        
            }
        }
    }
    
    
    func checkIfUserLikeTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
}
