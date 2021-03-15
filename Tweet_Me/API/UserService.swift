//
//  UserService.swift
//  Tweet_Me
//
//  Created by mai ng on 3/1/21.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String,completion: @escaping(User) -> Void) {
            
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            // Cache this information from snapshots value as a dictionary
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            
            guard let username = dictionary["username"] as? String else {return}
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
            
            
        }
        
    }
    
    func fetchUser(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionaty  = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User (uid: uid, dictionary: dictionaty)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        
        guard let currenUid = Auth.auth().currentUser?.uid else {return}

        REF_USER_FOLLOWING.child(currenUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currenUid: 1], withCompletionBlock: completion)
        }
        print("DEBUG: Current uid \(currenUid) started following  \(uid)")
        print("DEBUG: uid \(uid)  gained \(currenUid) as a follower")
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currenUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currenUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currenUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currenUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currenUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            print("DEBUG: User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationalStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let followers = snapshot.children.allObjects.count
//            print("DEBUG: Followers count is \(followers)")
        
        REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let following = snapshot.children.allObjects.count
//            print("DEBUG: Following  \(following) people")
            
            let stats = UserRelationalStats(following: following, followers: followers)
            completion(stats)
            }
        }
    }
    
    
    func updateProfileImage(image: UIImage,completion: @escaping(URL?) -> Void) {
        // Update profile image
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, err) in
            // How we get our download URL
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                // Set our profileImageUrl
                let values = ["profileImageUrl": profileImageUrl]
                
                // Update our user values with this new profileImageUrl

                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)){
        // Update our current users infomation in the database
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        let values = ["fullname": user.fullname,
                     "username": user.username,
                     "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values)
    }
    
}
