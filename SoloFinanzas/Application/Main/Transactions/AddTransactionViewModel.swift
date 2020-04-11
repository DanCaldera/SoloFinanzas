//
//  AddTransaction.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 10/04/20.
//  Copyright © 2020 Platzi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SoloFinanzasCore
import FirebaseAuth

class AddTransactionViewModel {
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func add(name: String, description: String, value: String) {
        guard let value = Float(value) else {
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let transaction = SoloFinanzasCore.Transaction(
            value: value,
            category: .expend,
            name: name,
            date: Date()
        )
        
        guard var data = transaction.data() else {
            return
        }
        
        data["ownerId"] = uid
        
        db.collection("transactions").addDocument(data: data) { (error) in
            print(error?.localizedDescription ?? "Object added")
            NotificationCenter.default.post(name: Notification.Name("AddedNewData"), object: nil)
        }
    }
}
