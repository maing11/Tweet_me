//
//  UserService.swift
//  Tweet_Me
//
//  Created by mai ng on 2/27/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            // Cache this information from snapshots value as a dictionary
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            
            guard let username = dictionary["username"] as? String else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            print("DEBUG: Username is \(user.username)")
            print("DEBUG: Username is \(user.fullname)")
            completion(user)
            
            
            
//            let user = User(fullname: <#String#>, email: <#String#>, username: username, profileImageUrl: <#String#>, uid: <#String#>)
        
        }
        
    }
}
