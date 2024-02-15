//
//  FirebaseManager.swift
//  WATT
//
//  Created by Glib Galchenko on 10/01/24.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct FirebaseConstants {
    static let users = "users"
}

final class FirebaseManager {
    
    let authentication: Auth
    let storage: Storage
    let firestore: Firestore
    
    init() {
        self.authentication = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
    
    
    func createAnonymousUserInDB(user: DBUser) async throws {
        var userData: [String:Any] = [
            "user_id" : user.uid,
            "is_anonymous" : user.isAnonymous,
            "data_created" : user.dateCreated
        ]
        
        if let email = user.email, let fullName = user.fullName, let phoneNumber = user.phoneNumber, let photoURL = user.photoURL {
            userData["email"] = email
            userData["full_name"] = fullName
            userData["phone_number"] = phoneNumber
            userData["photo_url"] = photoURL
        }
        
        try await firestore.collection(FirebaseConstants.users).document(user.uid).setData(userData)
    }
    
    func createUserInDB(user: DBUser) async throws {
        try firestore.collection(FirebaseConstants.users).document(user.uid).setData(from: user)
    }
    
    func checkIfUserExists(user: AppUser, completion: @escaping ((Bool) -> Void)) {
        firestore.collection(FirebaseConstants.users).document(user.uid).getDocument { document, error in
            guard let document = document else { return }
            if document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getUserFromDB() async throws -> DBUser {
        guard let uid = authentication.currentUser?.uid else {
            throw URLError(.badServerResponse)
        }
        return try await firestore.collection(FirebaseConstants.users).document(uid).getDocument(as: DBUser.self)
    }
    
    func editUserNameInDB(name: String) async throws {
        guard let uid = authentication.currentUser?.uid else { return }
        
        try await firestore.collection(FirebaseConstants.users).document(uid).updateData([
            "name" : name
        ])
    }
    
    func editPhoneNumberInDB(phoneNumber: String) async throws {
        guard let uid = authentication.currentUser?.uid else { return }
        
        try await firestore.collection(FirebaseConstants.users).document(uid).updateData([
            "phone_number" : phoneNumber
        ])
    }
    
}
