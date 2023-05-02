//
//  PaymentCard.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023/5/2.
//

import Foundation

struct PaymentCard: Wallet, Codable, Identifiable, Hashable {
    // MARK: 存储值
    var id = UUID()
    var name: String
    var transactions: [Transaction]
    var credit: Int = 0
    var shortcut: URL?
    
    // MARK: 计算值
    static let sampleSet = [
        PaymentCard(name: "蚂蚁花呗", transactions: Transaction.sample(5), credit: 500000),
        PaymentCard(name: "校园卡", transactions: Transaction.sample(), shortcut: URL(string: "https://www.example.com")),
        PaymentCard(name: "数字人民币", transactions: Transaction.sample(7))
    ]
    
    var balance: Int {
        self.credit - self.transactions.reduce(0) { partialResult, transaction in
            return partialResult + transaction.total
        }
    }
}
