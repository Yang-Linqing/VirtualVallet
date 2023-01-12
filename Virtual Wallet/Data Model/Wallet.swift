//
//  Wallet.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import Foundation

struct Wallet: Codable, Identifiable, Hashable {
    // MARK: 存储值
    var id = UUID()
    var name: String
    var transactions: [Transaction]
    
    // MARK: 计算值
    
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
    
    // MARK: 更新交易
    mutating func deleteTransactions(_ selection: Set<UUID>) {
        transactions.removeAll { transaction in
            selection.contains(transaction.id)
        }
    }
    
    mutating func squashTransactions(_ selection: Set<UUID>) {
        var newTotal = 0
        var newDate = Date()
        var newType = "压缩"
        var types = Set<String>()
        var index: Int!
        for (i, transaction) in transactions.enumerated() {
            if selection.contains(transaction.id) {
                if index == nil {
                    index = i
                    newDate = transaction.date
                }
                newTotal += transaction.total
                types.insert(transaction.type)
            }
        }
        if types.count == 1 {
            newType = types.first!
        }
        deleteTransactions(selection)
        transactions.insert(Transaction(date: newDate, total: newTotal, type: newType), at: index)
    }
    
    mutating func squashTransactionsByType(_ selection: Set<UUID>) {
        transactions.sort { newer, older in
            newer.date > older.date
        }
        var i = 0
        var indexOf = [String: Int]()
        while i < transactions.count {
            let transaction = transactions[i]
            
            if selection.contains(transaction.id) {
                if let j = indexOf[transaction.type] {
                    transactions[j].total += transaction.total
                    transactions.remove(at: i)
                    continue
                } else {
                    indexOf[transaction.type] = i
                }
            }
            
            i += 1
        }
    }
    
    subscript(index: UUID) -> Transaction {
        get {
            return self.transactions.first { $0.id == index } ?? Transaction()
        }
        set(newValue) {
            guard newValue.id == index else {
                return
            }
            let idx = self.transactions.firstIndex(where: { $0.id == index })!
            self.transactions[idx] = newValue
        }
    }
}

