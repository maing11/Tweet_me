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
    
    
    func uploadTweet(caption:String, completetion: @escaping(Error?,DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //Cast this value as a dictionary
        let values = ["uid": uid, "timestamp": Int(NSTimeIntervalSince1970), "likes": 0, "retweet": 0, "caption": caption] as [String : Any]
        //childByAutoId  is going to just automatically generate this unique identifier for us
        REF_TWEETS.childByAutoId().onDisconnectUpdateChildValues(values,withCompletionBlock: completetion)
        
        
    }
}
