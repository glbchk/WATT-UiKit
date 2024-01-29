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

final class FirebaseManager {
    
    let authentication: Auth
    let storage: Storage
    let firestore: Firestore
    
    init() {
        self.authentication = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
    
    
}
