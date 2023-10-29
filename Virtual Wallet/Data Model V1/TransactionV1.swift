//
//  Transaction.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import Foundation

/// 表示一笔交易。
struct TransactionV1: Codable, Identifiable, Hashable {
    var id = UUID()
    
    var date: Date
    
    /// 交易金额。
    ///
    /// 以分为单位。正值使钱包余额增加，负值使钱包余额减少。
    var total: Int
    var type: String
    
    init(id: UUID = UUID(), date: Date = Date(), total: Int = 0, type: String = "") {
        self.id = id
        self.date = date
        self.total = total
        self.type = type
    }
    
    static let sampleSet = [
        TransactionV1(date: Date(), total: -256, type: "小餐馆"),
        TransactionV1(date: Date(), total: -5500, type: "KFC"),
        TransactionV1(date: Date(), total: -2500, type: "美食"),
        TransactionV1(date: Date(), total: -512, type: "零食"),
        TransactionV1(date: Date(), total: -1024, type: "小餐馆"),
        TransactionV1(date: Date(), total: -2560, type: "美食城"),
        TransactionV1(date: Date(), total: -1280, type: "美食城"),
        TransactionV1(date: Date(), total: -1920, type: "美食城"),
        TransactionV1(date: Date(), total: 1080, type: "小餐馆"),
        TransactionV1(date: Date(), total: 222, type: "小餐馆"),
        TransactionV1(date: Date(), total: 666, type: "小餐馆"),
    ]
    
    static func sample(_ max: Int = -1) -> [TransactionV1] {
        if max <= 0 {
            return sampleSet.shuffled()
        } else {
            return Array(sampleSet.shuffled()[0..<max])
        }
    }
}

