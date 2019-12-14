//
//  TransactionsViewModel.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 14/12/19.
//  Copyright © 2019 Calere. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SoloFinanzasCore

protocol TransactionsViewModelDelegate {
    func reloadData()
}

class TransactionsViewModel {
    private var items: [SoloFinanzasCore.Transaction] = []
    
    private var db: Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = true
        db.settings = settings
        return db
    }
    
    var numberOfitems: Int {
        return items.count
    }
    
    var delegate: TransactionsViewModelDelegate?
    
    init() {
        db.collection("transactions").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self = self else { return }
            
            self.items.removeAll()
            
            try? snapshot?.documents.forEach({ (snapshot) in
                let json = snapshot.data()
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                
                guard let transaction = try? JSONDecoder().decode(Transaction.self, from: jsonData) else {
                    return
                }
                
                self.items.append(transaction)
            })
            
            self.delegate?.reloadData()
        }
    }
}
