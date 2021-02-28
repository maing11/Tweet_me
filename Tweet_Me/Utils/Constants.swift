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
