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

enum ActionType {
    case add
    case remove
}

struct FirebaseConstants {
    static let users = "users"
    static let anonymousUsers = "anonymous"
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
        try firestore.collection(FirebaseConstants.anonymousUsers).document(user.uid).setData(from: user)
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
    
    func updatePaymentMethods(card: PaymentMethod, actionType: ActionType) async throws {
        guard let user = authentication.currentUser else { return }
        let cardData = try Firestore.Encoder().encode(card)
        if actionType == .add {
            try await firestore.collection(FirebaseConstants.users).document(user.uid).updateData([
                "payment_methods" : FieldValue.arrayUnion([cardData])
            ])
        } else if actionType == .remove {
            try await firestore.collection(FirebaseConstants.users).document(user.uid).updateData([
                "payment_methods" : FieldValue.arrayRemove([cardData])
            ])
        }
    }
    
    func updateSelectedPaymentMethods(_ paymentMethod: PaymentMethod) async throws {
        guard let user = authentication.currentUser else { return }
        let paymentMethod = try Firestore.Encoder().encode(paymentMethod)
        try await firestore.collection(FirebaseConstants.users).document(user.uid).updateData([
            "payment_methods" : paymentMethod
        ])
    }
    
//    func editEmailConfirmedInDB(isEmailConfirmed: Bool) async throws {
//        guard let uid = authentication.currentUser?.uid else { return }
//        
//        try await firestore.collection(FirebaseConstants.users).document(uid).updateData([
//            "is_email_confirmed" : isEmailConfirmed
//        ])
//    }
    
}
