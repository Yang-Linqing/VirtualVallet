//
//  Transaction.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023-10-28.
//

import Foundation
import SwiftData


/// 交易信息。
///
/// 记录购物支付或账户间转账信息。
@Model
final class Transaction {
    var date: Date
    var total: Int
    /// 交易类型描述。
    ///
    /// 例如“早餐”、“夜宵”等。为简化记账，不记录详细信息，例如买了什么东西，吃了什么饭。
    var type: String
    /// 此交易计入的虚拟钱包。
    weak var wallet: Wallet?
    
    init(date: Date = Date(), total: Int = 0, type: String = "", wallet: Wallet? = nil) {
        self.date = date
        self.total = total
        self.type = type
        self.wallet = wallet
    }
}
