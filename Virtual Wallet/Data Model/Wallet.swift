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
    var transactionGroups: [TransactionGroup] {
        var date: Date!
        var result: [TransactionGroup] = []
        var group: TransactionGroup!
        transactions.forEach { transaction in
            if date == nil {
                group = TransactionGroup(date: transaction.date, transactions: [transaction])
                date = transaction.date
            } else {
                if Calendar.current.isDate(transaction.date, inSameDayAs: date) {
                    group.transactions.append(transaction)
                } else {
                    result.append(group)
                    group = TransactionGroup(date: transaction.date, transactions: [transaction])
                    date = transaction.date
                }
            }
        }
        if group != nil {
            result.append(group)
        }
        return result
    }
    
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
}

