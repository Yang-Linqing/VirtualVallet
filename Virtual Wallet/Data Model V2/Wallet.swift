//
//  Wallet.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023-10-28.
//

import Foundation
import SwiftData

@Model
final class Wallet {
    var name: String
    var credit: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.wallet)
    var transactions: [Transaction]
    
    init(name: String = "", credit: Int = 0, transactions: [Transaction] = []) {
        self.name = name
        self.credit = credit
        self.transactions = transactions
    }
}
