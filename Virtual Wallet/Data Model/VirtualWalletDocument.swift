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

struct VirtualWalletDocument: FileDocument, Codable {
    static var readableContentTypes: [UTType] = [.json]
    
    var primaryWallet: VirtualWallet
    var secondaryWallet: [VirtualWallet]
    var otherWallet: [VirtualWallet]
    var paymentCards: [PaymentCard]!
    
    init(
        primaryWallet: VirtualWallet = VirtualWallet(
            name: "每日饮食",
            transactions: []
        ),
        secondaryWallet: [VirtualWallet] = [
            VirtualWallet(name: "其他", transactions: [])
        ],
        otherWallet: [VirtualWallet] = [
            VirtualWallet(name: "小金库", transactions: [])
        ],
        paymentCards: [PaymentCard] = [
            PaymentCard(name: "银行卡", transactions: [])
        ]
    ) {
        self.primaryWallet = primaryWallet
        self.secondaryWallet = secondaryWallet
        self.otherWallet = otherWallet
        self.paymentCards = paymentCards
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            logger.log(level: .error, "无法读取文件数据。文件可能已经被移动或删除。")
            throw CocoaError(.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let document = try decoder.decode(Self.self, from: data)
        self = document
        if self.paymentCards == nil {
            self.paymentCards = []
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        logger.log("开始保存文件。")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        logger.log("文件序列化完成。")
        logger.log("小组件更新: 开始。")
        let entry = WalletBalanceEntry(
            primary: WalletEntryData(name: self.primaryWallet.name, balance: self.primaryWallet.balance),
            secondary: self.secondaryWallet.map({ wallet in
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


extension Int {
    var currencyString: String {
        String(format: "¥ %.2f", Double(self)/100)
    }
}

struct DocumentKey: EnvironmentKey {
    static var defaultValue: Binding<VirtualWalletDocument> = .constant(VirtualWalletDocument())
}

extension EnvironmentValues {
    var document: Binding<VirtualWalletDocument> {
        get { self[DocumentKey.self] }
        set { self[DocumentKey.self] = newValue }
    }
}

extension View {
    func document(_ document: Binding<VirtualWalletDocument>) -> some View {
        environment(\.document, document)
    }
}
