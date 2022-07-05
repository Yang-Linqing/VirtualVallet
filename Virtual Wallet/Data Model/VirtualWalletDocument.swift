//
//  VirtualWalletDocument.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog

fileprivate let logger = Logger(subsystem: "cool.linkin.Virtual-Wallet", category: "Document")

struct VirtualWalletDocument: FileDocument, Codable {
    static var readableContentTypes: [UTType] = [.json]
    
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
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
    
}


extension Int {
    var currencyString: String {
        String(format: "¥ %.2f", Double(self)/100)
    }
}
