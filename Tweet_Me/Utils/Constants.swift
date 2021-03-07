//
//  Constants.swift
//  Tweet_Me
//
//  Created by mai ng on 2/26/21.
//

import Firebase


let STORAGE_REFF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REFF.child("profile_images")
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")


