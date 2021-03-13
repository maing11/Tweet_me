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
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweet": 0,
                      "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            
            REF_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
                //Update user-tweet structure after tweet upload completes
                guard let tweetID = ref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            // When we reply to somebody it's going to give us the user name of the person who  made the original tweet
            values["replyingTo"] = tweet.user.username
            
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values) { (err, ref) in
                    
                    guard let replyKey = ref.key else {return}
                    REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID:replyKey], withCompletionBlock: completion)
                    
            }
        }
    }

    // This function should give us back an array of tweets
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { (snapshot) in
            //use user id and take going to their user tweet structure
            let followingUid = snapshot.key
            
            REF_USER_TWEETS.child(followingUid).observe(.childAdded) { (snapshot ) in
                let tweetID = snapshot.key
                
                self.fetchTweet(withTweetID: tweetID) { (tweet) in
                    tweets.append(tweet)
                    completion(tweets)
                    
                }
            }
            
        }
        REF_USER_TWEETS.child(currentUid).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { (tweet) in
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
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else {return}
            
            
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                let replyID = snapshot.key // ReplyID in database
              
                // Pass the uid in this func when we want fetch the user
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
                
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
    
    
    func fetchLikes(forUser user: User,completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            self.fetchTweet(withTweetID: tweetID) { (likedTweet) in
                var tweet = likedTweet
                tweet.didLike = true
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
