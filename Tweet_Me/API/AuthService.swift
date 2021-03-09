//
//  AuthService.swift
//  Tweet_Me
//
//  Created by mai ng on 2/26/21.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    //Statis only has get instantiated one time
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String,completion: AuthDataResultCallback?) {
        print("DEBUG: Email is \(email), password :\(password)")
        
        Auth.auth().signIn(withEmail: email, password: password,completion:completion )
        
    }
    
    func registerUser(credentials:AuthCredentials,completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        
        let email = credentials.email
        let  password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        //Convert that profile image from its current state into a data object
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        //Upload it into the data base
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    // We have new I.D as a part of this result
                    guard  let uid = result?.user.uid else {return}
                    // Create our data dictionary
                    let values = ["email": email,
                                  "password": password,
                                  "username":username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    
                    
                    //Essentially creating that URL String , that going to make sure it puts the database in the right place in the internet because this is a cloud based database
                    //Creat this user structure with that dot child users
                    // Creat this user structure with child uid
                    //Update the childValues with new information
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock:completion)
                
                }
                
            }
        }
    }
}


