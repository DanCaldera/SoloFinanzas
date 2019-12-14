//
//  Numeric.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 12/12/19.
//  Copyright © 2019 Calere. All rights reserved.
//

import Foundation

extension Numeric {
    func currency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let formatted = formatter.string(from: self as! NSNumber) else {
            return "\(self)"
        }
        
        return formatted
    }
}

