//
//  WidgetDataModel.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/10.
//

import WidgetKit

struct WalletBalanceEntry: TimelineEntry, Codable {
    let date: Date
    
    let primary: WalletEntryData
    let secondary: [WalletEntryData]
    
    init(date: Date = Date(), primary: WalletEntryData, secondary: [WalletEntryData]) {
        self.date = date
        self.primary = primary
        self.secondary = secondary
    }
    
    static let placeholder = WalletBalanceEntry(
        primary: WalletEntryData(name: "主要钱包", balance: 6000),
        secondary: [
            WalletEntryData(name: "次要钱包", balance: 102400),
            WalletEntryData(name: "次要钱包", balance: 690000)
        ]
    )
}

struct WalletEntryData: Codable {
    let name: String
    let balance: Int
}
