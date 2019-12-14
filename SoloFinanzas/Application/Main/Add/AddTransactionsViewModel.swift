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

class AddTransactionsViewModel {
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func add(name: String, description: String, value: String) {
        guard let value = Float(value) else {
            return
        }
        
        let transaction = SoloFinanzasCore.Transaction(
            value: value,
            category: .expend,
            name: name,
            date: Date()
        )
        
        guard let data = transaction.data() else {
            return
        }
        
        db.collection("transactions").addDocument(data: data)
    }
}
