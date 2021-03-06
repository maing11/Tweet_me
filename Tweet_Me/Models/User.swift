//
//  User.swift
//  Tweet_Me
//
//  Created by mai ng on 2/27/21.
//

import Foundation
import Firebase



struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationalStats?
    
    
    var isCurrentUser : Bool {return Auth.auth().currentUser?.uid == uid}
    
    
    init(uid: String,dictionary:[String:AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String{
            guard  let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
            
        }

    }
}

struct UserRelationalStats  {
    var following: Int
    var followers: Int
}
