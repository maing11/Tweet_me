//
//  ProfileFilterOptions.swift
//  Tweet_Me
//
//  Created by mai ng on 3/2/21.
//

import UIKit
import Firebase

enum ProfileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    //Create this description var to get back the text we want for each cell
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct  ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followingString: NSAttributedString? {
        return attributeText(withValue: 2, text: "following")
        
    }
    var followersString: NSAttributedString? {
        return attributeText(withValue: 0, text: "followers")

    }
    
    var actionButtonTitle: String {
        // IF uer is current user then set to edit profile
        // else figure out following /not following
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
        
    }
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributeText(withValue value: Int,text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string:  "\(value)",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray]))
        
        return attributedTitle
    }
    
     
}
