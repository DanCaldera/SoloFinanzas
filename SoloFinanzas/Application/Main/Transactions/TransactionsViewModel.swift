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
import FirebaseAuth

protocol TransactionsViewModelDelegate {
    func reloadData()
}

class TransactionsViewModel {
    private var items: [SoloFinanzasCore.Transaction] = []
    
    private var db: Firestore {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.isPersistenceEnabled = true
        db.settings = settings
        return db
    }
    
    var numberOfitems: Int {
        return items.count
    }
    
    var delegate: TransactionsViewModelDelegate?
    
    init() {
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: Notification.Name("AddedNewData"), object: nil)
    }
    
    @objc private func getData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("transactions")
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
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
                
                transaction.firebaseId = snapshot.documentID
                self.items.append(transaction)
            })
            
            self.delegate?.reloadData()
        }
    }
    
    func item(at indexPath: IndexPath) -> TransactionViewModel {
        return TransactionViewModel(transaction: items[indexPath.row])
    }
    
    func remove(at indexPath: IndexPath) {
        let item = items.remove(at: indexPath.row)
        guard let firebaseId = item.firebaseId else { return }
        db.collection("transactions").document(firebaseId).delete()
    }
}

class TransactionViewModel {
    private var transaction: SoloFinanzasCore.Transaction
    
    var name: String {
        return transaction.name
    }
    
    var value: String {
        return transaction.value.currency()
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: transaction.date)
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: transaction.date)
    }
    
    init(transaction: SoloFinanzasCore.Transaction) {
        self.transaction = transaction
    }
}
