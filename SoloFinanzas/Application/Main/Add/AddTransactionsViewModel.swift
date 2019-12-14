//
//  AddTransactions.swift
//  PlatziFinanzas
//
//  Created by Daniel Caldera on 12/14/19.
//  Copyright © 2018 Calere. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SoloFinanzasCore
import FirebaseAuth

class AddTransactionsViewModel {
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
