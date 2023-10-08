//
//  VirtualWalletDocument.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog
import WidgetKit

fileprivate let logger = Logger(subsystem: "cool.linkin.Virtual-Wallet", category: "Document")

/// 虚拟钱包的数据模型，负责左右的数据的存储和操作。
final class VirtualWalletStore: ReferenceFileDocument {
    static var readableContentTypes: [UTType] = [.json]
    
    @Published var document: VirtualWalletDocument
    
    init() {
        self.document = VirtualWalletDocument()
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            logger.log(level: .error, "无法读取文件数据。文件可能已经被移动或删除。")
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.document = try decoder.decode(VirtualWalletDocument.self, from: data)
    }
    
    func snapshot(contentType: UTType) throws -> VirtualWalletDocument {
        return self.document
    }
    
    func fileWrapper(snapshot: VirtualWalletDocument, configuration: WriteConfiguration) throws -> FileWrapper {
        logger.log("开始保存文件。")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(snapshot)
        logger.log("文件序列化完成。")
        logger.log("小组件更新: 开始。")
        let entry = WalletBalanceEntry(
            primary: WalletEntryData(name: snapshot.primaryWallet.name, balance: snapshot.primaryWallet.balance),
            secondary: snapshot.secondaryWallet.map({ wallet in
                WalletEntryData(name: wallet.name, balance: wallet.balance)
            })
        )
        let entryData = try encoder.encode(entry)
        if let userDefaults = UserDefaults(suiteName: "group.cn.ylqdev.Virtual-Wallet") {
            userDefaults.set(String(data: entryData, encoding: .utf8), forKey: "cn.ylqdev.Virtual-Wallet.Widget.WalletBalance")
            WidgetCenter.shared.reloadTimelines(ofKind: "cn.ylqdev.Virtual-Wallet.Widget.WalletBalance")
            logger.log("小组件更新: 完成。")
        } else {
            logger.log(level: .error, "小组件更新: 无法访问 App 与小组件的共享配置。")
        }
        return FileWrapper(regularFileWithContents: data)
    }
}

extension VirtualWalletStore {
    var primaryWallet: Wallet {
        document.primaryWallet
    }
    var secondaryWallet: [Wallet] {
        document.secondaryWallet
    }
    var otherWallet: [Wallet] {
        document.otherWallet
    }
    
    var allWallet: [Wallet] {
        [primaryWallet] + secondaryWallet + otherWallet
    }
    
    var total: Double {
        let intTotal = document.primaryWallet.balance + document.secondaryWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        }) + document.otherWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        })
        return Double(intTotal) / 100
    }
    
    func insert(_ transaction: Transaction, into wallet: Wallet) {
        if primaryWallet.id == wallet.id {
            document.primaryWallet.transactions.insert(transaction, at: 0)
        }
        for (idx, w) in secondaryWallet.enumerated() {
            if w.id != wallet.id {
                continue
            }
            document.secondaryWallet[idx].transactions.insert(transaction, at: 0)
        }
        for (idx, w) in otherWallet.enumerated() {
            if w.id != wallet.id {
                continue
            }
            document.otherWallet[idx].transactions.insert(transaction, at: 0)
        }
    }
}

/// 旧的虚拟钱包 JSON 文档模型。现在用于描述 JSON 根对象。
struct VirtualWalletDocument: Codable {
    
    var primaryWallet: Wallet
    var secondaryWallet: [Wallet]
    var otherWallet: [Wallet]
    
    init(
        primaryWallet: Wallet = Wallet(
            name: "每日饮食",
            transactions: []
        ),
        secondaryWallet: [Wallet] = [
            Wallet(name: "其他", transactions: [])
        ],
        otherWallet: [Wallet] = [
            Wallet(name: "小金库", transactions: [])
        ]
    ) {
        self.primaryWallet = primaryWallet
        self.secondaryWallet = secondaryWallet
        self.otherWallet = otherWallet
    }
    
}

extension Int {
    var currencyString: String {
        String(format: "¥ %.2f", Double(self)/100)
    }
}

extension String {
    static var localCurrencyID: String {
        Locale.current.currency?.identifier ?? "CNY"
    }
}
