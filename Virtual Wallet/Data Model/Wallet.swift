//
//  Wallet.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import Foundation

struct Wallet: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var transactions: [Transaction]
    
    /// 钱包余额。
    ///
    /// 值为所有交易金额之和。
    var balance: Int {
        self.transactions.reduce(0) { partialResult, transaction in
            return partialResult + transaction.total
        }
    }
    
    static let sampleSet = [
        Wallet(name: "每日饮食", transactions: Transaction.sample(5)),
        Wallet(name: "其他", transactions: Transaction.sample()),
        Wallet(name: "小金库", transactions: Transaction.sample(7))
    ]
    
    var transactionTypeSuggestions: [String] {
        var suggestions = Set<String>()
        var result = [String]()
        transactions.forEach { transaction in
            if !suggestions.contains(transaction.type) {
                result.append(transaction.type)
                suggestions.insert(transaction.type)
            }
        }
        return result
    }
}

