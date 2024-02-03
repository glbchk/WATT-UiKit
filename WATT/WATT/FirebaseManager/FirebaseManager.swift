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
    
    func createUserInDB(user: AppUser) async throws {
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
    
    func getUserFromDB() async throws -> AppUser {
        guard let uid = authentication.currentUser?.uid else {
            throw URLError(.badServerResponse)
        }
        return try await firestore.collection(FirebaseConstants.users).document(uid).getDocument(as: AppUser.self)
    }
    
}
