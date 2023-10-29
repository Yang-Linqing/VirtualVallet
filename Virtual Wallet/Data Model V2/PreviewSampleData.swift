//
//  PreviewSampleData.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023-10-29.
//

import SwiftData

struct SampleData {
    static var wallets: [Wallet] = [
        Wallet(name: "吃喝"),
        Wallet(name: "花呗", credit: 500000),
        Wallet(name: "银行卡")
    ]
    
    static var transactions: [Transaction] = [
        Transaction(total: -256, type: "小餐馆"),
        Transaction(total: -5500, type: "KFC"),
        Transaction(total: -2500, type: "美食"),
        Transaction(total: -512, type: "零食"),
        Transaction(total: -1024, type: "小餐馆"),
        Transaction(total: -2560, type: "美食城"),
        Transaction(total: -1280, type: "美食城"),
        Transaction(total: -1920, type: "美食城"),
        Transaction(total: 1080, type: "小餐馆"),
        Transaction(total: 222, type: "小餐馆"),
        Transaction(total: 666, type: "小餐馆"),
    ]
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Wallet.self, Transaction.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Wallet>()).isEmpty {
            SampleData.wallets.forEach { modelContext.insert($0) }
        }
        if try modelContext.fetchCount(FetchDescriptor<Transaction>()) == 0 {
            SampleData.transactions.forEach { transaction in
                transaction.wallet = SampleData.wallets.randomElement()
                modelContext.insert(transaction)
            }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

